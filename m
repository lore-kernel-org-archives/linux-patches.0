Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E231E487;
	Tue, 27 Aug 2024 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770755; cv=none; b=SYlUchEijDyj5HieKwdeYKj7xAftjLWZU01t+7Ugn3mX3KwYluIEih35IcszyeNQeBE0V/H/ubaQ4nGiSWi/8OEv+PS4JRfvr0AKr2SpwXS9zcSZwEvR0nL6EgYriUJEtRSJN8rjGsZp+Ops9b5TnvEJIbmkaKYdcFyiFVWBv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770755; c=relaxed/simple;
	bh=DKHb/M8cjhzi4aImefk/VZ098wKlO10CQKjBW8KEos4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2mXkKPE2XLR83Xrb7l0yF1jAN33HeDYGfhvRlF9b3aiCGMtEc7eAfdYg/83H/st65feP3fQf1fS0dvQWCy7qUDaS0AcvWfSuEQUqS0hNmKsWqlXrRLK2zKBGwxQFaidoDg8/Yq/JGPkH09u5ByCXeh4+fvkMljY33J9KhhIJL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpTIHsht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpTIHsht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF2AC61044;
	Tue, 27 Aug 2024 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770755;
	bh=DKHb/M8cjhzi4aImefk/VZ098wKlO10CQKjBW8KEos4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpTIHshtnSq1jf/SL+nEqD0zWoZy05tIHS8HS/vS7DW/PvoOhceKMJcD7I5kHErnO
	 IyDVEd4c1y9+xOlGuTrcwVGFm2SQq0ZwZMN42iqnhFRdcXGcVtR876YVDuiFmeq8Xx
	 poD8XYuVcLQe00O0mUOpeT8cExj7NjwNHyBa4Hog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc <1marc1@gmail.com>,
	"Anthony Nandaa (Microsoft)" <profnandaa@gmail.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/341] smb: client: ignore unhandled reparse tags
Date: Tue, 27 Aug 2024 16:38:44 +0200
Message-ID: <20240827143854.544475757@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ec686804117a0421cf31d54427768aaf93aa0069 ]

Just ignore reparse points that the client can't parse rather than
bailing out and not opening the file or directory.

Reported-by: Marc <1marc1@gmail.com>
Closes: https://lore.kernel.org/r/CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com
Fixes: 539aad7f14da ("smb: client: introduce ->parse_reparse_point()")
Tested-by: Anthony Nandaa (Microsoft) <profnandaa@gmail.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 689d8a506d459..48c27581ec511 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data)
 {
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
-		return 0;
+		break;
 	default:
-		cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
-			 __func__, le32_to_cpu(buf->ReparseTag));
-		return -EOPNOTSUPP;
+		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
+			      le32_to_cpu(buf->ReparseTag));
+		break;
 	}
+	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-- 
2.43.0



