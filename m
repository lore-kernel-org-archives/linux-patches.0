Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2D1F890E;
	Tue,  3 Dec 2024 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241716; cv=none; b=WDiGv27ac6AnvRIaZXaGPX1UiVAv2XfNBUayCALXvF7doI8q1sU/VSas4p4mnjxLzMBg0Pyg9d/bHNuYNGuhKsreRMfniB2d9sLsieuGOZRVhtYA2SwMG2l3sHBdZyFm1ZyqwsxYNiF2qe417k8e3VrZCJSvoQ599d8/DQAQza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241716; c=relaxed/simple;
	bh=0l2lxkN061Dg8opGvNzybL+Pu0Fx1GEBGCKUuIuEYj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tt9h4BXBIUBAuqfXRWSUai85KgxX4oQ3+I3EbXrXkrVhaQEVgTn3CzVb7QuBUlC22OzmHb1Kj7VoHJSM8oD7Bj5dmbX7VJkIjSDQUyStS0ZxM+ngTu9rXwzXul9GbOyelDkXkrfVUlkBc7PmjfYcmMI5vR9FOpvfbQ9MSFhaTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/hSOTnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/hSOTnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A693FC4CED8;
	Tue,  3 Dec 2024 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241716;
	bh=0l2lxkN061Dg8opGvNzybL+Pu0Fx1GEBGCKUuIuEYj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/hSOTnnjbYX6OGr3Qkwdfvk0mBwCvgXOaOM95ry6vr/mINuk9rjKjN9UczZ9o2Fw
	 uba9xn9Yh/DzyE5JNmInwGRjsV95u45r3lOHL2QAwSqznYNPgtkJvj2CqtxTlj1TtD
	 tidTX6fNJ96x96t+sxd76vJlzgpjvSSK68BEFUQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra Yashvant Shinde <ravindra.yashvant.shinde@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/826] i3c: master: Remove i3c_dev_disable_ibi_locked(olddev) on device hotjoin
Date: Tue,  3 Dec 2024 15:43:43 +0100
Message-ID: <20241203144803.103190006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6f3eb710a75d6..ffe99f0c6acef 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2051,11 +2051,16 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
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



