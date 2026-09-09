Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F325955C1D6;
	Wed,  9 Sep 2026 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964074; cv=none; b=SgHyRnIvEObNzR8LQ9bwYO53rDR65+f4ak3Rn4AZBqPmNfAYI9HAHJT7AA9qY9GsECmElJgXseIzWhA5mZ/+2+IIZM1UYlGXXT4hS16cGV2ujZyf23zGD+6Bsoy5ddqDcYFuDwDqhBjiDeIdeB7RoUEdv6QT9ArfSgtJbw+In3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964074; c=relaxed/simple;
	bh=Trs5fqiJOkRACGFTzqBwcTJEOTW40fHxqU5uWCCKjHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnBQB5ZyxUlL7AwtqmbZWfSpPLrsEm+1pnLfEIWDy6aTQD9PHQvYv+jghnZxL1nmQdgvKW5QxwGtR4EFc+0ea5T6iua8lNwGs0GSirpXeBiRL7ssOBWrquI46vVToIcTgWGzy7W8+EXwsdk8ljyJJ8M7thZNfmvL0JrqcGKNUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTQWY4WZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTQWY4WZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502551F00A3A;
	Wed,  9 Sep 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964072;
	bh=P7UxP5/bj5BdxCdvyvhw9EYy6D5Ve8brSqjJsLzEoLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTQWY4WZvKAPsGcPCfHaDdRIjcbyhXlcZYLGzkBpnx6luzLFHvuJqFOYdhRCWcp+z
	 Hl2OOBA9VZfGrhE5oBuCSkS8k0RqL5Tdnh7MWWeIS2qQw6vcs+LY4ZsUpAIXa/QTE8
	 aK51rIq/6+B8n/yXcmN/E61SjPUZ0JwHu1kvNeNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 297/583] media: platform: mtk-mdp3: Fix SCP device refcounting
Date: Wed,  9 Sep 2026 15:39:42 +0200
Message-ID: <20260909134248.317814776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 55793e4665b7f15151e6f5ab51ca980e73abed5d upstream.

mdp_probe() first tries to get the SCP handle with scp_get(). When that
fails, it falls back to looking up the SCP platform device with
__get_pdev_by_id() and then reads its driver data.

The fallback lookup returns the platform device with a reference, just
like scp_get() does. However, the fallback path currently drops that
reference immediately after platform_get_drvdata(). The driver later
still calls scp_put(mdp->scp) unconditionally from the probe error path
and from mdp_video_device_release(), which drops the SCP device
reference again.

Keep the fallback reference until the existing scp_put() call, so that
the fallback path follows the same ownership rules as the scp_get()
path.

Fixes: 8f6f3aa21517 ("media: platform: mtk-mdp3: fix device leaks at probe")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -292,7 +292,6 @@ static int mdp_probe(struct platform_dev
 			goto err_destroy_clock_wq;
 		}
 		mdp->scp = platform_get_drvdata(mm_pdev);
-		put_device(&mm_pdev->dev);
 	}
 
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);


