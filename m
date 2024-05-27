Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B4168C4;
	Mon, 27 May 2024 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837498; cv=none; b=OVh5fZw8Vjf5jBDj8CFZjc6i0cjw9Jk+TKu54/fuSs53+dDegJusXKEnaXHIakBh3A1GwY3uVDDdv85nIgtdo6sFBF6XZ5czsdDXIGf0e13XD6vzjhic8U6XBDQ+UWJf6EJoiam9KgHCdjRTdjjKkgOFBgxLPXdhW/4ccRPB8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837498; c=relaxed/simple;
	bh=SViLp8lbk0HqNUh5XnMITSZEEmhm9iUXCNUX7Gthuro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0tJIdlUx7A/YLGLj1/8Ds11YWCVdO9ZN5HypTSmko4jR+3tuMcjcpxL4AJuNq+kkqMa1XRJc5t1DkfvORrzv51sAzjpn41dtCP41XMQbjvW+z9NKHVVBjrtzBudVW/FReO/G0rqXHyI9S6H17lXGcO3PNUwBPCfOWqX5VbEI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Kils9Bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Kils9Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B50DC2BBFC;
	Mon, 27 May 2024 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837498;
	bh=SViLp8lbk0HqNUh5XnMITSZEEmhm9iUXCNUX7Gthuro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Kils9BsgYy+MhnDzJzqWRn8JJ52CaLZ4AMNQS/hAslAHmW2sbIYvEl47t+5QN4UR
	 Va54TzQQxb5YHBEUH2c5uNelKmkwXsL4tbOvvBx+mQKFY8zOiJs3fWr1PKlQUPpoOO
	 Vd2nrcnp7QNQCJfcQNjbdx6qDF3l5Mv1/mKD5jFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <bonifaido@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 033/493] ksmbd: ignore trailing slashes in share paths
Date: Mon, 27 May 2024 20:50:35 +0200
Message-ID: <20240527185629.565164306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


