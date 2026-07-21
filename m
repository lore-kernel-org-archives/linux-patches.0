Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D72433BAC;
	Tue, 21 Jul 2026 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663922; cv=none; b=RdDbE6mMdBFMdh+0SZuXo7xSOJnoeUAW1RRn+vN7yblt3DQ3ImOaPh1m7QOzz6IwQ1wSPl3LYMwRF3UbxyvKEjYKdJtbQdR5l/MkVCsFtegwZJ8bIUGs8hqqTLYMFxSXAHn9X5j6j5DN4W45iEcFUzv61xNjRIHCp9cnUguwkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663922; c=relaxed/simple;
	bh=R+M6UM1mpixgsn2AF3W2Ke0MMWEDmgaqnyqgn1iaV2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNlnyC27wC31C5G53vvo3OM3T8M26EQZVaTF1d+lTumI7PzRDVQgq33nza/WYEtICmAqMfEA49UHOo5tJxCfCKE8zzUJxwi+FRCG15ji2cbhYoU5nRVZjgnAuTxIc4QGuacz4SpSw81tmJsjiH5VIxNqakj+7ESXwQas+HVAmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/HHnR2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/HHnR2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF63B1F00A3A;
	Tue, 21 Jul 2026 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663919;
	bh=tYfEx4y5eX5wd+s6iA9LVrLFUO3g4qpbc8I4QohUw70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/HHnR2Cl5PD8KiZNPk/YoloWWChVmKTdTAU2kP32TVLKPrek/pNBYYpG60n3YtYW
	 YuczFlfxs+tChnix4ATd2avVYrR+M0Ps0XA08f79+oAOeRX5UCSk1z2VmE1kTWqoTw
	 /G+ip/IrL5ubg4poDOBnAdQl+nYOoJPEd2+OVRG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1004/1276] dm-ioctl: fix a possible overflow in list_version_get_info
Date: Tue, 21 Jul 2026 17:24:07 +0200
Message-ID: <20260721152508.477569868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 76c6f845dc0c614304a6e6ee619b552f97cf24b3 upstream.

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -683,7 +683,7 @@ static void list_version_get_info(struct
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}


