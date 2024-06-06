Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829CD19E7D5;
	Thu,  6 Jun 2024 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683105; cv=none; b=DqO77Ri2NFhUMMYdF+WZ/FaLYrHoUC3CFljPG4wVylBGxpBXw3NajyGMsx8Em8nT6F+j5xz7lX16ZUOEQidtC4mKIlwmLgcNKUyS03Dz3KiQKXtdQ5cyTKrZjgz3Z/8Kud3r3SIcLwoMaiAZ8WKRdQldYRsTE2Zlo9UAp+CTopU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683105; c=relaxed/simple;
	bh=9kWtbCj87WBdXadwoT2hSjIkQQQHpKUtjMt3xYqdbdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVhjfv9Zu5ofVa0kJ7xhx5VAC2jdJluA/oJoZQhyfk0UUre+Kndogi8aWRAkVYThXa+4Pvy/F7VlPDcP8lcxB2D5vAP8gxHk7AZPxeFrwkQvdcmn+yZ9mk0HGqUQMJKIu0enF9/3B+xayofmYlk3gxG6gLathFXuMtQXu45rNyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeRkAcv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeRkAcv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628E4C2BD10;
	Thu,  6 Jun 2024 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683105;
	bh=9kWtbCj87WBdXadwoT2hSjIkQQQHpKUtjMt3xYqdbdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeRkAcv1QaaeZ+Sd5nEukMqrXXv/z8+sARgrd9gVKSDINXOFpP2aF2FgD1YmKgXzN
	 UfDS2gnJOwxOsZUcnoo445bnzo/8hAlQs5psVt/TLxCGjotQuIhWdpPUBKw8UbT/Tx
	 2rhnXhXGBVuCbMAImD2j1AOg6FhH81M/CGIqcKaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <bonifaido@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 028/744] ksmbd: ignore trailing slashes in share paths
Date: Thu,  6 Jun 2024 15:55:00 +0200
Message-ID: <20240606131733.353837941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Nandor Kracser <bonifaido@gmail.com>

commit 405ee4097c4bc3e70556520aed5ba52a511c2266 upstream.

Trailing slashes in share paths (like: /home/me/Share/) caused permission
issues with shares for clients on iOS and on Android TV for me,
but otherwise they work fine with plain old Samba.

Cc: stable@vger.kernel.org
Signed-off-by: Nandor Kracser <bonifaido@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/share_config.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -165,8 +165,12 @@ static struct ksmbd_share_config *share_
 
 		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      GFP_KERNEL);
-		if (share->path)
+		if (share->path) {
 			share->path_sz = strlen(share->path);
+			while (share->path_sz > 1 &&
+			       share->path[share->path_sz - 1] == '/')
+				share->path[--share->path_sz] = '\0';
+		}
 		share->create_mask = resp->create_mask;
 		share->directory_mask = resp->directory_mask;
 		share->force_create_mode = resp->force_create_mode;


