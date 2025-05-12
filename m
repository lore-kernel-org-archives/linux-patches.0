Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C532BF3F2;
	Mon, 12 May 2025 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073134; cv=none; b=QFFMVFRvniZgz+iZ2qoF3aFI2UGNVowZjIKZ0BSwBO8pQnlXGOnlgdl4m6toBEtRqEPnVaSrB/PKzpqU4ofbE8Azug0bYuXQ+bGpywMriouwFUaMGEMph2HHfJdl2DgX6Rg/XsuDO2nR8iej0YVy317r0AyMk/iAj4nOOHB30Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073134; c=relaxed/simple;
	bh=W5zPkgd3X79X1K3mJF1Ln71+bGwPFHDYGAq45/4MhSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I46ah4OBsy0Mr9ffABtWANFOGsnrSnfrEmOFtUUKvnezmxAkN8NTHczxYHr8Y0Eh3zhkI1OlimpFmWdKYX/tFSIzg50iVklwN+An0lxifKFJFl9Ur2pXm0Bp4YaslPFbAx/MoHYo9CrW7+RWCAo/oI0A2Ta2aVykYB/SEZoDMcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZJ+g8Kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZJ+g8Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3A2C4CEE9;
	Mon, 12 May 2025 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073133;
	bh=W5zPkgd3X79X1K3mJF1Ln71+bGwPFHDYGAq45/4MhSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZJ+g8KwUG7Ru8TqSx5PrtI9/azm5RK6NEogFTXNjAG4gSZxPPZ96vYcewIbKsajG
	 jcMQMmEvl3EK3rujxUySKDV3/jHyMOhguLv+PIWfSGiHxFI8R9G4a7uk3gXgaIkHAZ
	 0f3K8Wn1R9gs0xgl51up/154nHl9fzE4jNMgk6yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.12 125/184] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon, 12 May 2025 19:45:26 +0200
Message-ID: <20250512172046.909463711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -296,6 +296,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


