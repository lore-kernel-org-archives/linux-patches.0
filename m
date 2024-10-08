Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B4F1DE88F;
	Tue,  8 Oct 2024 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393545; cv=none; b=RjT95FPQyPWxvmwSaltZwp7ncZ7FfMZC/kFtB2arTYqLgFaONZrTcOFrgAB7sgtecDw3PL+6K6p4UcJrw/JFQ5Z/EX0UCKLsqzWlIJJX9ED7Auadk0NREk7vawXfwxsHA092HEdvnVoG2nimAgCY6ep6/yBxyE9TqxCWRZccidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393545; c=relaxed/simple;
	bh=vwVprKqSzJkWrVLw7XaXWMSOfFiSS7lNBlQsEVcP0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwnaXkuk6iHQ6N0760EkYSAxz76Mf+GwcH5dQVZmPIbUhtgDuEunAvczK3UMHnvwbmfLjKYLn2C283lnqGdZG8g8U0uGa6WahNZuBzmfXoXXuhISL4849EWCLwB3mcfvEu9fWFvbQYYfN8Ukzk1zPN4oF4elR2tvoae89uNqr2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYMQA2uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYMQA2uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C47C4CEC7;
	Tue,  8 Oct 2024 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393544;
	bh=vwVprKqSzJkWrVLw7XaXWMSOfFiSS7lNBlQsEVcP0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYMQA2uzZ+SdrRESXIXq8WzCK8JUJC/8GEeULpHC0vP9O0ojzk7VfZ+c9FydqCJPa
	 +43Wg5miX++YtYiyZ3hlR7x3LRvhB/JPQK9KgFawXcDlJE3xsJbSoncbjSQhdyj8/Y
	 vaj/6PIz8dNYV7nMw02wnEY/xlyaKiollwN7eEAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/386] bpftool: Fix undefined behavior caused by shifting into the sign bit
Date: Tue,  8 Oct 2024 14:07:08 +0200
Message-ID: <20241008115636.613789349@linuxfoundation.org>
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

[ Upstream commit 4cdc0e4ce5e893bc92255f5f734d983012f2bc2e ]

Replace shifts of '1' with '1U' in bitwise operations within
__show_dev_tc_bpf() to prevent undefined behavior caused by shifting
into the sign bit of a signed integer. By using '1U', the operations
are explicitly performed on unsigned integers, avoiding potential
integer overflow or sign-related issues.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240908140009.3149781-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 66a8ce8ae0127..fd54ff436493f 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -480,9 +480,9 @@ static void __show_dev_tc_bpf(const struct ip_devname_ifindex *dev,
 		if (prog_flags[i] || json_output) {
 			NET_START_ARRAY("prog_flags", "%s ");
 			for (j = 0; prog_flags[i] && j < 32; j++) {
-				if (!(prog_flags[i] & (1 << j)))
+				if (!(prog_flags[i] & (1U << j)))
 					continue;
-				NET_DUMP_UINT_ONLY(1 << j);
+				NET_DUMP_UINT_ONLY(1U << j);
 			}
 			NET_END_ARRAY("");
 		}
@@ -491,9 +491,9 @@ static void __show_dev_tc_bpf(const struct ip_devname_ifindex *dev,
 			if (link_flags[i] || json_output) {
 				NET_START_ARRAY("link_flags", "%s ");
 				for (j = 0; link_flags[i] && j < 32; j++) {
-					if (!(link_flags[i] & (1 << j)))
+					if (!(link_flags[i] & (1U << j)))
 						continue;
-					NET_DUMP_UINT_ONLY(1 << j);
+					NET_DUMP_UINT_ONLY(1U << j);
 				}
 				NET_END_ARRAY("");
 			}
-- 
2.43.0



