Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2E32E3AF1;
	Sun,  7 Jun 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829564; cv=none; b=a3uxjIiwGzf0xOHMhUqksCeZcVINkcqj7Rkp+a9j1AkeRgTdcO/i/skIjK8yBjIB1Ge1+WwWbocYUMAjKlUC+8x2QoykSvCEx0XiVI+dsSP2gYUc0bg6wBde+eETYT0yPYnYNtm+p0ZSFFVE9zJsyPi0/EIRTgUCn7K6r8HejMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829564; c=relaxed/simple;
	bh=iBn8xnGReTDV8PX3SnIiyWBMktcynjWHfJicdjrzqQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBLSQLCdfkeUot05TsUFP41esn+KA4IVWlN8ihwzeDx3cgV9R0r+TEQVchHMFAnWT0mB/TuwHdOjIU6H08zi1D41PCKX3vNv7qIUslAuozKQuI7IxTAY34OSRuxQd5RYbqWDumubYN6SlUQO5ICvECkkhuXGF9GF7ALxP5w+/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbGDcWOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbGDcWOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC31F00893;
	Sun,  7 Jun 2026 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829563;
	bh=O3Xw0hgBE1FJ7Y9b7cqcTRC2xkbaWYIFtPeDB33nC1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbGDcWOB29ajg041zsqT12ZOf6uBQfsufEPp4qHNXmmlfaXK54NnFY9/O0gQXBTYE
	 jK10oUrnwbEBtopFo0xAwTUm6ZiV75gxJVEmFIP1Y0pkrtSCt1an4VMyg1GSS1kc1/
	 qh4oxVOKvb2LkwA1GBX3wHisBgNRczXY3rBW69Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 7.0 290/332] drm/gem: fix race between change_handle and handle_delete
Date: Sun,  7 Jun 2026 12:00:59 +0200
Message-ID: <20260607095738.700475098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1047,6 +1047,7 @@ int drm_gem_change_handle_ioctl(struct d
 	       goto out_unlock;
        }
 
+	idr_replace(&file_priv->object_idr, NULL, args->handle);
 	spin_unlock(&file_priv->table_lock);
 
 	if (obj->dma_buf) {
@@ -1055,6 +1056,7 @@ int drm_gem_change_handle_ioctl(struct d
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
 			idr_remove(&file_priv->object_idr, handle);
+			idr_replace(&file_priv->object_idr, obj, args->handle);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
 		}


