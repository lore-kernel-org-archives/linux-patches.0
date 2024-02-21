Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C07C08D;
	Wed, 21 Feb 2024 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522034; cv=none; b=Y9t5p8xxsyWPowYPXYbSqxCkmWdRzW2HrQhTb6j/ujSwkMz+SAbXFmivbdi3Nsczwt8Q7ZdHCtCUCJ/6DhOXtWXD8gpdjc6DMSrBLLXbLIT4pywwiuWE1emVVrhgW3i7hsBJvDQG2Vf1gpwf0GP3983gLfoPsXNtrbs1ANe74X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522034; c=relaxed/simple;
	bh=H085vX9IPKzFhBYGAZjFchiEeDfs61g/xm/kuvq8cZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwtN3EqxZYOFgpTJ+u91cYrTjQTF+IzzH75WIlK4FFOBiEeJUydxu5BXL4CNte1CM1b+JLedHnpcH0zbWONTf3y4xJYCzdBKQTJvcdkpPxyE+PRzmiovzSujoJENCsC4tVnKUQMkvJBPGe+XJo1o/NGaAv7gWHAYZdrr0k5nt1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZdITSzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZdITSzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C22C433C7;
	Wed, 21 Feb 2024 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522034;
	bh=H085vX9IPKzFhBYGAZjFchiEeDfs61g/xm/kuvq8cZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZdITSzmby/zVq8BSbjApPsZByApoKLGg993+4+jRBRcakcY6vSbGRhNTHQBvdfYu
	 jnB+v5V56LQu8OgFN8QmDAM0y2jZszPRAkkESE7KbcTByGrP7JTN8tfb2sJYGmsq+6
	 5BrSMKsTHzV7BiRAYmQUuK40989PrvGXH2M+lOg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Dipietro <dipiets@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/476] tcp: Add memory barrier to tcp_push()
Date: Wed, 21 Feb 2024 14:01:45 +0100
Message-ID: <20240221130009.920247008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salvatore Dipietro <dipiets@amazon.com>

[ Upstream commit 7267e8dcad6b2f9fce05a6a06335d7040acbc2b6 ]

On CPUs with weak memory models, reads and updates performed by tcp_push
to the sk variables can get reordered leaving the socket throttled when
it should not. The tasklet running tcp_wfree() may also not observe the
memory updates in time and will skip flushing any packets throttled by
tcp_push(), delaying the sending. This can pathologically cause 40ms
extra latency due to bad interactions with delayed acks.

Adding a memory barrier in tcp_push removes the bug, similarly to the
previous commit bf06200e732d ("tcp: tsq: fix nonagle handling").
smp_mb__after_atomic() is used to not incur in unnecessary overhead
on x86 since not affected.

Patch has been tested using an AWS c7g.2xlarge instance with Ubuntu
22.04 and Apache Tomcat 9.0.83 running the basic servlet below:

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloWorldServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        OutputStreamWriter osw = new OutputStreamWriter(response.getOutputStream(),"UTF-8");
        String s = "a".repeat(3096);
        osw.write(s,0,s.length());
        osw.flush();
    }
}

Load was applied using wrk2 (https://github.com/kinvolk/wrk2) from an AWS
c6i.8xlarge instance. Before the patch an additional 40ms latency from P99.99+
values is observed while, with the patch, the extra latency disappears.

No patch and tcp_autocorking=1
./wrk -t32 -c128 -d40s --latency -R10000  http://172.31.60.173:8080/hello/hello
  ...
 50.000%    0.91ms
 75.000%    1.13ms
 90.000%    1.46ms
 99.000%    1.74ms
 99.900%    1.89ms
 99.990%   41.95ms  <<< 40+ ms extra latency
 99.999%   48.32ms
100.000%   48.96ms

With patch and tcp_autocorking=1
./wrk -t32 -c128 -d40s --latency -R10000  http://172.31.60.173:8080/hello/hello
  ...
 50.000%    0.90ms
 75.000%    1.13ms
 90.000%    1.45ms
 99.000%    1.72ms
 99.900%    1.83ms
 99.990%    2.11ms  <<< no 40+ ms extra latency
 99.999%    2.53ms
100.000%    2.62ms

Patch has been also tested on x86 (m7i.2xlarge instance) which it is not
affected by this issue and the patch doesn't introduce any additional
delay.

Fixes: 7aa5470c2c09 ("tcp: tsq: move tsq_flags close to sk_wmem_alloc")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240119190133.43698-1-dipiets@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 86dff7abdfd6..0659f0d9414d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -722,6 +722,7 @@ void tcp_push(struct sock *sk, int flags, int mss_now,
 		if (!test_bit(TSQ_THROTTLED, &sk->sk_tsq_flags)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTOCORKING);
 			set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
+			smp_mb__after_atomic();
 		}
 		/* It is possible TX completion already happened
 		 * before we set TSQ_THROTTLED.
-- 
2.43.0



