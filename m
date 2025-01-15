Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E48156644;
	Wed, 15 Jan 2025 10:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938353; cv=none; b=Tij7+B0brGoT9cxAeD09hBrPrWW5xVB4IicHW91AUpjKc7afRxPtXg6dIBZwfcJqz429cYSMZ3JLwlMfoRpCb5n1pXJpA/0y0ayDcD0D6eBEMmrG64ciCdXnJS5lUzIVOqt4nZK+GI2uVekZNarCqI34MkQ+q8zOWlXtk48qLrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938353; c=relaxed/simple;
	bh=5n5G/uDckvyTPZf4nWhpeJnTE7viQPLWO6ppBzhysiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnXKjilDWlOLqvEkwoKe5Gug2/Im15whtHskTcU8vEvhXkZ0dekXVbdX+ImMAjdqN3fH+5sYnEeZQSFwtf0H6lJ5emBJFdx+RN5GeIVXZYxBMLLyN3dXDXWNBBftJGq7GydJsOdUqqPfmOEOxpi5rPMDl699QJrU4xPjgrdA8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDdmmMPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDdmmMPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354AFC4CEDF;
	Wed, 15 Jan 2025 10:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938353;
	bh=5n5G/uDckvyTPZf4nWhpeJnTE7viQPLWO6ppBzhysiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDdmmMPgjlEGw+Fs/JfM8wK+gXjuSJj0498ARIZZuvDMtT9dl/GCC3+DnsJJsRz09
	 BKmlRXXIe+IGff30V1TRkW4bE1sJIlAOwnv5IfxKLRdZoHfuxzk4qcii0aNALU6xmZ
	 SIfh73GvjXi1VMXsJ06p/6Q83eyOu+4beJkBjEuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 156/189] usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
Date: Wed, 15 Jan 2025 11:37:32 +0100
Message-ID: <20250115103612.637373700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: GONG Ruiqi <gongruiqi1@huawei.com>

commit b0e525d7a22ea350e75e2aec22e47fcfafa4cacd upstream.

The error handling for the case `con_index == 0` should involve dropping
the pm usage counter, as ucsi_ccg_sync_control() gets it at the
beginning. Fix it.

Cc: stable <stable@kernel.org>
Fixes: e56aac6e5a25 ("usb: typec: fix potential array underflow in ucsi_ccg_sync_control()")
Signed-off-by: GONG Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250107015750.2778646-1-gongruiqi1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -646,7 +646,7 @@ static int ucsi_ccg_sync_control(struct
 			UCSI_CMD_CONNECTOR_MASK;
 		if (con_index == 0) {
 			ret = -EINVAL;
-			goto unlock;
+			goto err_put;
 		}
 		con = &uc->ucsi->connector[con_index - 1];
 		ucsi_ccg_update_set_new_cam_cmd(uc, con, &command);
@@ -654,8 +654,8 @@ static int ucsi_ccg_sync_control(struct
 
 	ret = ucsi_sync_control_common(ucsi, command);
 
+err_put:
 	pm_runtime_put_sync(uc->dev);
-unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


