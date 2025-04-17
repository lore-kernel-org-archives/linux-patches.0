Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F17B256C61;
	Thu, 17 Apr 2025 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916121; cv=none; b=XJ8Wi+9LwIlhn0emaUf4W+D80ErS9xEk5ejG/0LNBEcdqeE2/TGvxnZArGrLjCwc3DXgRC02noa0xfYZ2H+toUlaVpQt2Qdd6bBtue3AUFIW1ZXmZFC8IZR34Gwr4QuqZrnDfnzdzszO8vfz68gs9B0yks4gm+Il2MjVRH/FR3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916121; c=relaxed/simple;
	bh=lSps/gaY6G+vvmAFFa0z4RLXbe+IsPirMPe6M3XawL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DN2uSXvXAH0G+wXKtx5FOiFweo0NU524PIgSHICxXL71Ug21ZzOLhWHGUZh44YYvUeFyZbBQplEvNTWw9yrZQkbBQjzJT3cGz2W7c3h1KM56ReshIqcLAvNbTTtE7Bi+qunSIn1DOYXdF+Hgy19JbfdaVEyGyL0WUNeaUI4viYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuK2qxeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuK2qxeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266EAC4CEE4;
	Thu, 17 Apr 2025 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916120;
	bh=lSps/gaY6G+vvmAFFa0z4RLXbe+IsPirMPe6M3XawL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuK2qxeLBdbPEK5sh+cKb8r08PWEzsnHCQaB40hR0Zps9M5/Q8iZnOP1K06EDqt/m
	 mpkqZQ/+rs0XiqVrleFau/gPD0GFGaZ5gAQO1xyFmjz4P1LGME4xq8JoiJUt3lF2xM
	 /Y6IPGbFrPOkMUR4l9yTy8o6uTahpt960sStG2mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 320/393] cifs: fix integer overflow in match_server()
Date: Thu, 17 Apr 2025 19:52:09 +0200
Message-ID: <20250417175120.491713124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

commit 2510859475d7f46ed7940db0853f3342bf1b65ee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1287,6 +1287,11 @@ static int smb3_fs_context_parse_param(s
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


