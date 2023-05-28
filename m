Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0162611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCA3C433D2;
	Sun, 28 May 2023 19:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303425;
	bh=uyvgc5IBlqbpLkRDLg12ZWWMsmOVAwK+JnJsQncTa1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD1wkIp9D39fqdG7WyjK7vn15LTDki+3blpCKj4YNokzkOHdrKc/ogHQYGTnVoJTO
	 2MNfCbxG+TKMKYKbIUo3OuvmSTyZsOc9SjSxBR/pnMOEDizJ1xIb5MlqxsjKXDxup2
	 kK3xz1hc4PGip3zIHcDSvaq9/uxlBBKpEgmlHZfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Spivey <tspivey8@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 41/69] cifs: mapchars mount option ignored
Date: Sun, 28 May 2023 20:12:01 +0100
Message-Id: <20230528190829.901355456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

commit cb8b02fd6343228966324528adf920bfb8b8e681 upstream.

There are two ways that special characters (not allowed in some
other operating systems like Windows, but allowed in POSIX) have
been mapped in the past ("SFU" and "SFM" mappings) to allow them
to be stored in a range reserved for special chars. The default
for Linux has been to use "mapposix" (ie the SFM mapping) but
the conversion to the new mount API in the 5.11 kernel broke
the ability to override the default mapping of the reserved
characters (like '?' and '*' and '\') via "mapchars" mount option.

This patch fixes that - so can now mount with "mapchars"
mount option to override the default ("mapposix" ie SFM) mapping.

Reported-by: Tyler Spivey <tspivey8@gmail.com>
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -884,6 +884,14 @@ static int smb3_fs_context_parse_param(s
 			ctx->sfu_remap = false; /* disable SFU mapping */
 		}
 		break;
+	case Opt_mapchars:
+		if (result.negated)
+			ctx->sfu_remap = false;
+		else {
+			ctx->sfu_remap = true;
+			ctx->remap = false; /* disable SFM (mapposix) mapping */
+		}
+		break;
 	case Opt_user_xattr:
 		if (result.negated)
 			ctx->no_xattr = 1;


