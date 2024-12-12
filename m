Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9658222D44;
	Thu, 12 Dec 2024 15:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018693; cv=none; b=s2ak/1Ets6LoKKzbeGEo4oWYVx6jFaT/ycoOKLDmQECOs0Rhr1aoqNQ+mfo9beNO7hd4I7Wiy54qCriaaN/Vm+0jBAxCVrzJ7NI6oCmUWwe6UsC87FwubsYxHiuizAICCVRJdgShzHVHIxXcLzB1ypS+VHh05r9K0bi+mx6/Vig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018693; c=relaxed/simple;
	bh=rgABftn1QCRFJRyG5RHqIam4gU0aIn92HmkYbnUsqRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH+vwW/8NRurRkm/pqRCYpzT1G5NjwfZPhZbEzmoyniRW5yvKUpMW3B/Hg5T9MT9rplz0I0mw0QvcLyLeOzeBRB8RF98OGdveqj3uORVFfoLDEz4MgDi/QWNoyDjf9M2dbiEPvczVIRezfs7NGdw+coZILdQyYH33FtxfyYFpss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj8i1uyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj8i1uyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324DBC4CECE;
	Thu, 12 Dec 2024 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018693;
	bh=rgABftn1QCRFJRyG5RHqIam4gU0aIn92HmkYbnUsqRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj8i1uyL3K1bAMU3i9x3jgSYI32P7yrvEAIBzdi2CIDYJyV4ck95KshgN9kkuBuvz
	 Wvlmqe81lXiS+BhAFFioIdN4kjS4JcKqqzLBJBlfBw3x0ucvq8TfPWvUxOxUV17zAs
	 ayKzmShJcXFD3CMHHxpj3Lr4TRzZLZTg04kSp2vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra Yashvant Shinde <ravindra.yashvant.shinde@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 355/356] i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin
Date: Thu, 12 Dec 2024 16:01:14 +0100
Message-ID: <20241212144258.594768842@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit 36faa04ce3d9c962b4b29d285ad07ca29e2988e4 upstream.

When a new device hotjoins, a new dynamic address is assigned.
i3c_master_add_i3c_dev_locked() identifies that the device was previously
attached to the bus and locates the olddev.

i3c_master_add_i3c_dev_locked()
{
    ...
    olddev = i3c_master_search_i3c_dev_duplicate(newdev);
    ...
    if (olddev) {
        ...
        i3c_dev_disable_ibi_locked(olddev);
        ^^^^^^
        The olddev should not receive any commands on the i3c bus as it
        does not exist and has been assigned a new address. This will
        result in NACK or timeout. So remove it.
    }

    i3c_dev_free_ibi_locked(olddev);
    ^^^^^^^^
    This function internally calls i3c_dev_disable_ibi_locked() function
    causing to send DISEC command with old Address.

    The olddev should not receive any commands on the i3c bus as it
    does not exist and has been assigned a new address. This will
    result in NACK or timeout. So, update the olddev->ibi->enabled
    flag to false to avoid DISEC with OldAddr.
}

Include part of Ravindra Yashvant Shinde's work:
https://lore.kernel.org/linux-i3c/20240820151917.3904956-1-ravindra.yashvant.shinde@nxp.com/T/#u

Fixes: 317bacf960a4 ("i3c: master: add enable(disable) hot join in sys entry")
Co-developed-by: Ravindra Yashvant Shinde <ravindra.yashvant.shinde@nxp.com>
Signed-off-by: Ravindra Yashvant Shinde <ravindra.yashvant.shinde@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241001162232.223724-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2048,11 +2048,16 @@ int i3c_master_add_i3c_dev_locked(struct
 			ibireq.max_payload_len = olddev->ibi->max_payload_len;
 			ibireq.num_slots = olddev->ibi->num_slots;
 
-			if (olddev->ibi->enabled) {
+			if (olddev->ibi->enabled)
 				enable_ibi = true;
-				i3c_dev_disable_ibi_locked(olddev);
-			}
-
+			/*
+			 * The olddev should not receive any commands on the
+			 * i3c bus as it does not exist and has been assigned
+			 * a new address. This will result in NACK or timeout.
+			 * So, update the olddev->ibi->enabled flag to false
+			 * to avoid DISEC with OldAddr.
+			 */
+			olddev->ibi->enabled = false;
 			i3c_dev_free_ibi_locked(olddev);
 		}
 		mutex_unlock(&olddev->ibi_lock);


