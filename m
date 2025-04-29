Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597D253948;
	Tue, 29 Apr 2025 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949293; cv=none; b=SRdY4pSbdLQEIo6+wXRQBntBdZ9385MSVORuANJ5t/w9EcQV+elzbo9CrEfgj/Kta6LxtSONwSO9dc5WBvny79vmQfy+HQb3faS5Pk5ny2BPJ04NWzD9uCkvrOCVL8gx2N0M8Ds9HKHkRZ15gWLJMLKAlRIct1MAhZvPlevN5DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949293; c=relaxed/simple;
	bh=vyeKTg4UKhLKi8lKp9Ea8PU3q2TCynd+MCUEFuaUKuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udTIqoeEJ66SQyZttGsovjXYFMViE6E9DuL2l/acJye5OUzT7I9FX0MV3+UfOqi3Kma/pPVIc1aYgr92wOa5uoMtCLYizQbti3vrOLjFSZ8dspXA5dp60hIb4pjt2VNhGebPqowU0BLBGH0PsFcMyUYPSMVA8Lg0m1RVBcdSNIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZS4NEor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZS4NEor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8500EC4CEE3;
	Tue, 29 Apr 2025 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949293;
	bh=vyeKTg4UKhLKi8lKp9Ea8PU3q2TCynd+MCUEFuaUKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZS4NEorxRoWIrDQOt24oxQtr0CCiHdfjNfH55n4Vd+B6Yhetv3H6RAUgZdQSo3fW
	 uhcN2EXsPlNeUxLYdD/SNiu8IfJdrDBDLflf9YguSM1hN+EmU54baNxgVLExxdJCxu
	 apgsNI0smRjeqjFtRqYkVwKUM92s8BRKRCKKksOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/373] cifs: fix integer overflow in match_server()
Date: Tue, 29 Apr 2025 18:42:29 +0200
Message-ID: <20250429161134.319749772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 2510859475d7f46ed7940db0853f3342bf1b65ee ]

The echo_interval is not limited in any way during mounting,
which makes it possible to write a large number to it. This can
cause an overflow when multiplying ctx->echo_interval by HZ in
match_server().

Add constraints for echo_interval to smb3_fs_context_parse_param().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: adfeb3e00e8e1 ("cifs: Make echo interval tunable")
Cc: stable@vger.kernel.org
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 24c42043a2271..c3a71c69d3395 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1088,6 +1088,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->closetimeo = HZ * result.uint_32;
 		break;
 	case Opt_echo_interval:
+		if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
+		    result.uint_32 > SMB_ECHO_INTERVAL_MAX) {
+			cifs_errorf(fc, "echo interval is out of bounds\n");
+			goto cifs_parse_mount_err;
+		}
 		ctx->echo_interval = result.uint_32;
 		break;
 	case Opt_snapshot:
-- 
2.39.5



