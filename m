Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DD5582BA5;
	Wed,  9 Sep 2026 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963335; cv=none; b=ks8Sw+NRhg66nFCJISF96KEWvS7r3DogFZcmtaDHo22p4WdiKdOF8h4tu4xQrsNyd/q70Y4VYVRPLDvaLmIMj5ZnNg0JegGsjoOG8IOTrtvIJG5ZSQ+CchK3G9NpXQtxz++ZgKV+T6Tp7IW4RqaOeuHNI2odB5XJdKOflWin+bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963335; c=relaxed/simple;
	bh=G0TEcpRUA3thbL57EDU6dsPmHW1CF/heD69sooQidOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFFXoGXeUfmwxwtW+YKDdJF9p3zbcOglfedJ9YaD/vtCtvFyov1pW/8ShZucgfn9Gu1bhMHV5bEC0TVpAsbGsLqULGFc1pU8Y3AP5Qhr5PgbZdIZL4hucqxpQ6vPYRASIdVZReOpyEAXDmD+Lm9Lhrx0HCAvUVXgp3IFR/0N5hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq5bhqhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq5bhqhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582BC1F00A3A;
	Wed,  9 Sep 2026 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963333;
	bh=mZycmEFDx+gnfHbWwslz9uIflnRIPYZKvSb8ZQPKR4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rq5bhqhN1LIlHtJxis7suMrbCw1R7tPn7kwnltS5qfpnd0uCzeFm8xSCoJlXC5gQ3
	 jAVXhC+/PaKK2awA94f/RYbi2sI/PMshdh2GqjSSFHGarkVB5oRIcVxe6G59Dg1mDa
	 6haoRyl8zZJquMdqqlVFDIwAMFPozypsjGm+eD88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 044/583] scsi: target: iscsi: Reserve a terminator byte for the login payload
Date: Wed,  9 Sep 2026 15:35:29 +0200
Message-ID: <20260909134239.451083691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujal Tuladhar <sujaltuladhar1231@gmail.com>

commit f4825922d2fb371e2b969697d792077f1b62b62c upstream.

iscsi_target_check_login_request() rejects a login PDU whose
DataSegmentLength exceeds MAX_KEY_VALUE_PAIRS, but the test is '>' and
login->req_buf is allocated with exactly MAX_KEY_VALUE_PAIRS
bytes. Since iscsit_get_login_rx() receives payload_length + padding
bytes, where

	padding = ((-payload_length) & 3);

any payload_length from 8189 to 8192 fills the whole 8192 byte
buffer. The write stays in bounds, but no byte is left for a NUL
terminator.

The buffer is subsequently consumed as a C string. In the CHAP path
chap_check_algorithm() calls kstrdup(a_str), and extract_param() calls
strstr(in_buf, pattern) followed by strlen_semi(), none of which take a
length. convert_null_to_semi() additionally rewrites every embedded NUL
to ';', so even a payload made of well formed NUL separated key=value
records is left without a terminator. These walk past the end of the
object into adjacent slab memory. It is reachable by an unauthenticated
initiator against a portal configured for CHAP; when authentication is
not required iscsi_login_zero_tsih_s2() rewrites AuthMethod to None and
the CHAP path is never entered.

Allocate one extra byte. kzalloc() zeroes it and nothing ever writes to
it, as every writer copies to offset 0 for at most MAX_KEY_VALUE_PAIRS
bytes, so the buffer is always terminated.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Assisted-by: Claude Opus5 (custom harness)
Cc: stable@vger.kernel.org
Signed-off-by: Sujal Tuladhar <sujaltuladhar1231@gmail.com>
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target_login.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -47,7 +47,7 @@ static struct iscsi_login *iscsi_login_i
 	login->conn = conn;
 	login->first_request = 1;
 
-	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS + 1, GFP_KERNEL);
 	if (!login->req_buf) {
 		pr_err("Unable to allocate memory for response buffer.\n");
 		goto out_login;


