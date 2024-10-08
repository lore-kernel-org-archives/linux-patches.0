Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA531DED4E;
	Tue,  8 Oct 2024 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393555; cv=none; b=pm3pBGUyL2QmD7zXedjS/qntAUaNM9CU+pZ/n4B0VWywNS8krJyIrxB3lduyDZ/o2S5sMSXJLKlMCXxm+qkdgdAc8XezQRo8N7/sSJSxRdCIg4rFP+Pfr2DcfH5I7GdbmVsJGthcN02kowBWJT/uKs0k3SzOGy+vRkC3ls8KamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393555; c=relaxed/simple;
	bh=YC9E3bvTJ7hN49WtkAHje9Qk2NVVPjrS7COHf2H/ZGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd0X+ZgN0vgHxOr/iogi8FaPGgJJZsYDj8AOdfxFvzIk0nndKx/8iSFlgj72i1prmgceQTCHwTgBOVXtEtB3YU9pfolXZ6nNcBw9T138Rird66SEjP47aWlnJYVmM5hbTo09xvk84NRIfbq0NILJs5bDI7by5t+zwWeoML0jtZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dApZnxtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dApZnxtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD3FC4CEC7;
	Tue,  8 Oct 2024 13:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393555;
	bh=YC9E3bvTJ7hN49WtkAHje9Qk2NVVPjrS7COHf2H/ZGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dApZnxtLMnt0YgJcB+w4GBmBp9WOvkLo1W6qPFwelPIAHcHNT3SvK7jBVFCmHG0mx
	 mpV4w9wkHJ22kfYuzs0eGB2GQ5435bV6cQVyDKslAeQfghmXuA8dYwkUj/nrDvdUUg
	 p0hkK7YRysPmvbhWM/u6afVMZRQQwbV/cfCFVJlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/386] bpftool: Fix undefined behavior in qsort(NULL, 0, ...)
Date: Tue,  8 Oct 2024 14:07:10 +0200
Message-ID: <20241008115636.692458161@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit f04e2ad394e2755d0bb2d858ecb5598718bf00d5 ]

When netfilter has no entry to display, qsort is called with
qsort(NULL, 0, ...). This results in undefined behavior, as UBSan
reports:

net.c:827:2: runtime error: null pointer passed as argument 1, which is declared to never be null

Although the C standard does not explicitly state whether calling qsort
with a NULL pointer when the size is 0 constitutes undefined behavior,
Section 7.1.4 of the C standard (Use of library functions) mentions:

"Each of the following statements applies unless explicitly stated
otherwise in the detailed descriptions that follow: If an argument to a
function has an invalid value (such as a value outside the domain of
the function, or a pointer outside the address space of the program, or
a null pointer, or a pointer to non-modifiable storage when the
corresponding parameter is not const-qualified) or a type (after
promotion) not expected by a function with variable number of
arguments, the behavior is undefined."

To avoid this, add an early return when nf_link_info is NULL to prevent
calling qsort with a NULL pointer.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240910150207.3179306-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index fd54ff436493f..28e9417a5c2e3 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -819,6 +819,9 @@ static void show_link_netfilter(void)
 		nf_link_count++;
 	}
 
+	if (!nf_link_info)
+		return;
+
 	qsort(nf_link_info, nf_link_count, sizeof(*nf_link_info), netfilter_link_compar);
 
 	for (id = 0; id < nf_link_count; id++) {
-- 
2.43.0



