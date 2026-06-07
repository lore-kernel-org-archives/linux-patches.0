Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339A4071DD;
	Sun,  7 Jun 2026 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829547; cv=none; b=WM4na5CQCFzWRcTYHGdLHciMZilPXgOgMZvJQZ2C9mcJgk1wLW8Hg5+UmztLZdoEdDJyjNn9UfqzYN3TBHo0j596TQL4BdrFc1sb15OtFimXBQqcF/o4bRKrp9m0pLeenSRLSjvEbkFelBcAkGj7+/tTRNuzxGYhz81leWKlR8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829547; c=relaxed/simple;
	bh=VX+qVOjxPtvodOYAFKjS37teEA9bDqhZphK4UaQQm9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icfEOtBAjso0eM2qREqu3It9wKaaE2CsDrRX/ExXolqcUZP8Qj/+SAIB/4MmmXpIlSU5h9l8A0InhlNXnYYmhNNZg8JAOrMiYWj9b7XyMtErFq+F7GbfJQ+ZClaTtEWh8rIHJeIrCc6OTJK2C2G96f0HT39Y0kYUqF9YRJPlJ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm3MlPpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm3MlPpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C98B1F00893;
	Sun,  7 Jun 2026 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829546;
	bh=7exdBBjHPsJgtftCZe6Qdv5cn0STR9SAXit1vyl0ZYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm3MlPpbBaGypbz3HCQ5WU6CxKB/i//JU7SeRYNoXBalOJAaAnHx8HUNocP1V/4bU
	 CrZueK0azu3y2GRaw1Vi3U6PUdUZT4RGgwEsYyUCx8eb4DR0K7LSmRRgHWlYywy6F8
	 x68K9WEe0qlUYuGOg+1UjzoK/TB02uD9dkFBmJAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.18 257/315] drm/gem: fix race between change_handle and handle_delete
Date: Sun,  7 Jun 2026 12:00:44 +0200
Message-ID: <20260607095736.998485181@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Zhenghang Xiao <kipreyyy@gmail.com>

commit 7164d78559b0ff29931a366a840a9e5dd53d4b7c upstream.

drm_gem_change_handle_ioctl leaves the old handle live in the IDR
during the window between spin_unlock(table_lock) and the final
spin_lock(table_lock). A concurrent drm_gem_handle_delete on the old
handle succeeds in this window, decrements handle_count to 0, and frees
the GEM object while the new handle's IDR entry still references it.

NULL the old handle's IDR entry before dropping table_lock so that any
concurrent GEM_CLOSE on the old handle sees NULL and returns -EINVAL.
Restore the old entry on the prime-bookkeeping error path.

Fixes: 5e28b7b94408 ("drm: Set old handle to NULL before prime swap in change_handle")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260526085313.26791-1-kipreyyy@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1015,6 +1015,7 @@ int drm_gem_change_handle_ioctl(struct d
 	       goto out_unlock;
        }
 
+	idr_replace(&file_priv->object_idr, NULL, args->handle);
 	spin_unlock(&file_priv->table_lock);
 
 	if (obj->dma_buf) {
@@ -1023,6 +1024,7 @@ int drm_gem_change_handle_ioctl(struct d
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
 			idr_remove(&file_priv->object_idr, handle);
+			idr_replace(&file_priv->object_idr, obj, args->handle);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
 		}


