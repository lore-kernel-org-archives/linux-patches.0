Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78191DFC7;
	Wed,  3 Jul 2024 10:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003860; cv=none; b=UKZsvv++loiif8eCPOv/dpv5mEKmlPb/hBtrCzjTjreQF6CwosCxKYR373NOecBu6egdXc14Nplc3bLKbfwuQK9g74zIK2gcp4UZp9cQ4znHBnEstHq6unGI+vMusf3A4eHdRkxBjZS0WiHyc6PGkqZxcH0rQs/kxwFZkgGzLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003860; c=relaxed/simple;
	bh=056VZFEbdSpgX8pW5io2pJbc48HVP8qStPWO3WfGaMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtyW+xuW9RRLSCwSa9yM92MV6CAhWjzYHCwCdaf1cKgTDLxMwj7qq5UgXGO+/GAqekxdP7F2/oMXJSMulyJIfIyK0HSxNFO2r3FPQXbwU4/rKiI4DYBiDo4hGTQwAH8q0igm6pi1hrTzHoC3oFKlJq1nRlKQcjam4fNGunhy7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm6ADABY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm6ADABY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7A9C2BD10;
	Wed,  3 Jul 2024 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003860;
	bh=056VZFEbdSpgX8pW5io2pJbc48HVP8qStPWO3WfGaMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm6ADABYFgH8/y2H4LdgyfQ/nWCUjC5me5WPU4ZwVwW2obf+QBWqsod5Vv1ooL9Xh
	 AD5Neh9KuUrO0kmnCyXUSeWD9jHlleTKJbLKNzZD43lN4ZtZ1BAaVJj7BglBjJX7UD
	 j8YYo2uIzUeIcRQjakDxDlpAD9UfoFTZfHfwFGIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.4 044/189] mei: me: release irq in mei_me_pci_resume error path
Date: Wed,  3 Jul 2024 12:38:25 +0200
Message-ID: <20240703102843.175745201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 283cb234ef95d94c61f59e1cd070cd9499b51292 upstream.

The mei_me_pci_resume doesn't release irq on the error path,
in case mei_start() fails.

Cc: <stable@kernel.org>
Fixes: 33ec08263147 ("mei: revamp mei reset state machine")
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240604090728.1027307-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/pci-me.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -379,8 +379,10 @@ static int mei_me_pci_resume(struct devi
 	}
 
 	err = mei_restart(dev);
-	if (err)
+	if (err) {
+		free_irq(pdev->irq, dev);
 		return err;
+	}
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);


