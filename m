Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77632590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B45C433D2;
	Sun, 22 Jan 2023 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401195;
	bh=MgrnPs2DysF1KwZsRahnpCqovgJtXooyBL01CAcUZlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg/rOtyWjJYo3z/gtEcpEjC/wCosYo2sqgGcFeD/2026Zaa/7dzfmuLJ43UCWLBFi
	 R39umKEwvATmB2owKaoSo7gZo7yadsMCtzX63oXOrQ/AfVYYyewNLbKi1oOE/HAtGI
	 QpoDoElBa4RVdsLjh/U280Y4lPmwNW7kL5EWCAVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 129/193] mei: bus: fix unlink on bus in error path
Date: Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150252.218199010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit a43866856125c3c432e2fbb6cc63cee1539ec4a7 upstream.

Unconditional call to mei_cl_unlink in mei_cl_bus_dev_release leads
to call of the mei_cl_unlink without corresponding mei_cl_link.
This leads to miscalculation of open_handle_count (decrease without
increase).

Call unlink in mei_cldev_enable fail path and remove blanket unlink
from mei_cl_bus_dev_release.

Fixes: 34f1166afd67 ("mei: bus: need to unlink client before freeing")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20221212220247.286019-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -665,13 +665,15 @@ void *mei_cldev_dma_map(struct mei_cl_de
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
 
 	ret = mei_cl_dma_alloc_and_map(cl, NULL, buffer_id, size);
-out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 	if (ret)
 		return ERR_PTR(ret);
@@ -721,7 +723,7 @@ int mei_cldev_enable(struct mei_cl_devic
 	if (cl->state == MEI_FILE_UNINITIALIZED) {
 		ret = mei_cl_link(cl);
 		if (ret)
-			goto out;
+			goto notlinked;
 		/* update pointers */
 		cl->cldev = cldev;
 	}
@@ -748,6 +750,9 @@ int mei_cldev_enable(struct mei_cl_devic
 	}
 
 out:
+	if (ret)
+		mei_cl_unlink(cl);
+notlinked:
 	mutex_unlock(&bus->device_lock);
 
 	return ret;
@@ -1115,7 +1120,6 @@ static void mei_cl_bus_dev_release(struc
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
-	mei_cl_unlink(cldev->cl);
 	kfree(cldev->cl);
 	kfree(cldev);
 }


