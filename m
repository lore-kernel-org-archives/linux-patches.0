Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863335A3AD;
	Mon,  4 May 2026 14:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903645; cv=none; b=R/DHKTrfkGSg8bjfonXjigQTo9llRQ6vPgOdVrvKSWESZ7OsGOKUQK+Oamvw3kgxzbGGkqI9OUVmwyPhDZEE4vC35dD0V9LDE83LC0JS6r08QQBDdcrydAHswf0yss2i+KljF1nJHdGTFDCYrTtAFXyzifK+HEGsA19uzMqjkyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903645; c=relaxed/simple;
	bh=mWdd5RBq6qzZWLaWFE/XAV6Cj7wXZQVHU9397A7wJNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6Mg8r+yEmEQeZmuYaNdom3Pfq1lK9d7jscTTzEUIEOmYvtSTBDucLKXOehxhjptw28pH5T6aAnIsfAs3F/WjFYyWX9EgwofcdwxN6YMUGumQ0Y+TomcyOp3AfbRBejSTfDJuGZ7Lwi+eLwHSW7zTOujrgm7vpSNU+RA1CEkZKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1gdkbA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1gdkbA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E5FC2BCB8;
	Mon,  4 May 2026 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903644;
	bh=mWdd5RBq6qzZWLaWFE/XAV6Cj7wXZQVHU9397A7wJNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1gdkbA4r6ub5/Ps9Je/OW4YjNTl1EYz/hxqxI3x+/P/2t5FITExd9A2KE56f5eBY
	 fXFJjoNW4RKo3hda6TJOX8hZh6rXV3j5schLnfmXkTogWqhYO/T/upsBcyMiR/08hv
	 uadoVy/nq8sMVTM9zscqweOMCC7kT1uzuzv2uiyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 283/307] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Mon,  4 May 2026 15:52:48 +0200
Message-ID: <20260504135153.442418785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

commit 1e111c4b3a726df1254670a5cc4868cedb946d37 upstream.

If device_add(&sdkp->disk_dev) fails, put_device() runs
scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
referenced. The device_add_disk() error path in sd_probe() calls
put_disk(gd); call put_disk(gd) here to mirror that cleanup.

Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260330014952.152776-1-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4018,6 +4018,7 @@ static int sd_probe(struct scsi_device *
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


