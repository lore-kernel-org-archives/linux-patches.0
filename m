Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145A34E36D9;
	Thu, 17 Sep 2026 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666579; cv=none; b=pK1UFfMZ8CNON3kSwkLavIL6oT9/fPygYNMGQzRlFmH4z/fx8ZnBNhjDBPVFXdMH8h/LsHxuGx6nUzTsnRgYxTL4PHgXx+xa1kSUIqWzjX4jBZVyQFbZ1jhRNH2UxxG2J5v7sQc/WbNdeaFfcNyUxEAXdpBpHLvmDV5UiMcy5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666579; c=relaxed/simple;
	bh=h6bttuq/nWlN2dLH+FbkmBc2Dy6hi/qHbOPA09QzwAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa7dB+8DKHMIEHS4CA6iGydB4Bnyg6GWAmiI34v6JoQl40kr5TFM0tj5S5J9GKXshWRw5wlZMpgTdAwugmTV9IMKJ060k/4ZltRyVnoURRywY+/VISSltpOQEroZ/1G0sySonhrVnA2is+/E/vDoWSjIduUkaBIqeKvHR+EBKow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcKvZhK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcKvZhK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA11F000FF;
	Thu, 17 Sep 2026 17:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666577;
	bh=2hJOHXS6wZjtCXkOICm/2V1A3ftgT1+SIeE2aMq1qhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcKvZhK/Ua/0ZZPaZBSoIUv0e4JBVc9ECBv80CVHHWEFC85HI/eS87AejfIjGkdmA
	 TF5UYlyU25bDsXHvScgzLj3ToC+N3AGSznFF1fhYUOihJ4cu74xsE6LIJwLYR7QZbX
	 lYmXhbJ86D7VSzdw91HHI0FByzLLH8Op2CIlzSo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.18 1084/1250] smb: client: fix file type corruption in wsl_to_fattr()
Date: Thu, 17 Sep 2026 16:14:39 +0100
Message-ID: <20260917151621.534786381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit fa7a2cfcf1e6117fc478cae6809c66c518740969 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Clear S_IFMT before the switch statement.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1113,6 +1113,7 @@ static bool wsl_to_fattr(struct cifs_ope
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;


