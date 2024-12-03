Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EF81EF0AE;
	Tue,  3 Dec 2024 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239134; cv=none; b=WXmnBsJDFTppPP29Ff/NDJMzrdb3OjpmWdexkv/7UaRcH00XQzqZ1+2BSbgYSWDbD8Y+u/TBg6N8fW3AT2iNrnxFnqfICKc+6BfkoFGI85x/SRch5tMQRp/nab6pQxDBzwUqrOtNo5R6TwBi/PP9Q3qoZ1judi+8fYvplLGKHTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239134; c=relaxed/simple;
	bh=Zx9S6Rn3cOD6OHZFJG5cU6hWdq2809rAnz3aMFugPHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhBPf6ntkKpflpvGbocZ5TvG6/9CrRLqIQtyHb8U8YLhvUfeTkUmL3LGW59NOCi9VCPMEeu6+kgRYMfImdZp1zEXCWYVWl3gaMoR4hcwtOdUIUsjT7UmsyBInP8UiyvOysQbVjLGuUQMnA6UpHOz6hIQXW5tT0gqk/ueYcSCHLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mBb3s3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mBb3s3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE53C4CED6;
	Tue,  3 Dec 2024 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239134;
	bh=Zx9S6Rn3cOD6OHZFJG5cU6hWdq2809rAnz3aMFugPHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mBb3s3HfKRluyT3YIbJvwOBBYvlYFmsnYXV/4Qrf4xiQcNHAVWMIEP/xV0NPYmno
	 DuLM4JRB2Kziwzxb7zQqTD2iyT2GVzA6/04yXHBH2CaFheQ8uisRZZBw+OiROIqP1G
	 hXtWT5w+pBJppxBOJMoGHOeAIuxwF3Yr7vrtm7YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra Yashvant Shinde <ravindra.yashvant.shinde@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 507/817] i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin
Date: Tue,  3 Dec 2024 15:41:19 +0100
Message-ID: <20241203144015.662302125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 36faa04ce3d9c962b4b29d285ad07ca29e2988e4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 7028f03c2c42e..82f031928e413 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2039,11 +2039,16 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
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
-- 
2.43.0



