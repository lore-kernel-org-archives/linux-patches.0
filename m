Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06665143721;
	Tue, 14 May 2024 11:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686059; cv=none; b=DjzkD6HRb7Sauq7tsSNY7y1Bc5ZDKSAfUWS8D01igkesmG48EjLP1V5kOyJzfSNn5sQ01LwLBhc0d32WTY3iHEmE2MeAM8PXCWfqqqm9FGbuvFyR1aF2ixb2iTj8GV7uVhKXMLTuWkfWDsuOG4xVI8g4k32rcPHfRvEawYL1uzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686059; c=relaxed/simple;
	bh=dYIkfNZzJy/v+UNUbHHeUU01g7T4QPgsp2msNDjFSQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DndxgzFvlLxO6rpuOXxqsw3ePkY/lw2l/lD/bLeFnkTaEvNln+RLiuOKK9ZAGrqfU7/sOqUuad9yMug2Ao3vZ2BPpEUvJpNXDWVYWpg/1NsSRykWwAOm5ilFwXVeKIaeXBj2+xpqABmkvxDMcX6jxVXCqhUSlGqe6vGncB3HB08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bipdx2kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bipdx2kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D91C2BD10;
	Tue, 14 May 2024 11:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686058;
	bh=dYIkfNZzJy/v+UNUbHHeUU01g7T4QPgsp2msNDjFSQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bipdx2kgEsI3dRibAQQ1754HowD6Ek5wVzhxoOCcjbbfgv8ImSlQKJMLRUC4ngeQj
	 mAyGzZ6PpsWlSvjW4KdBuF5fWOmNo2YRZ/z+6iIOpMw1GLo4xpJZFM6rznrM/65Jgc
	 Fg5Z05pR8HYeCj1n6UC0iw3dSRtGeBYV5yhSlW6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 301/301] Bluetooth: qca: fix firmware check error path
Date: Tue, 14 May 2024 12:19:32 +0200
Message-ID: <20240514101043.630623276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 40d442f969fb1e871da6fca73d3f8aef1f888558 upstream.

A recent commit fixed the code that parses the firmware files before
downloading them to the controller but introduced a memory leak in case
the sanity checks ever fail.

Make sure to free the firmware buffer before returning on errors.

Fixes: f905ae0be4b7 ("Bluetooth: qca: add missing firmware sanity checks")
Cc: stable@vger.kernel.org      # 4.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -605,7 +605,7 @@ static int qca_download_firmware(struct
 
 	ret = qca_tlv_check_data(hdev, config, data, size, soc_type);
 	if (ret)
-		return ret;
+		goto out;
 
 	segment = data;
 	remain = size;


