Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2126232C957;
	Fri, 17 Oct 2025 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715597; cv=none; b=lq+DGXOERDnPhBnugAlkch2EoZvO9Mz55/urTfAXpOUtFA8ignhu3Rd7vrw6q/8X5uPguzx4OnZ4rbEEslLhONFB7HLmDlxvDQiCED8wwAjddpsgDonHj4Pg/JdMaz9cOWqt5DGCrpFGXMZ6t1cagPfLToW7QY6t7NNer77wEHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715597; c=relaxed/simple;
	bh=3LRvCAdJA1flSoPZchJ6I7GvKBCXO/DULXN7xkY0bVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abapoLldn6sScpWqKJS52ZeauwWI3aVJngxn/dSe65hkl07HfeZxkeIK17TQs0VVwV1WMCXX9aaw84byhJ9pu1QUXoPUs0m59FN2YteHAhNynwICF/Ngporv/4x+PfxIDvjALt7ZpS3Kovy+H/KjyxsAu0SvvP6sQv8YkzpjP+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQttGrSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQttGrSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E044C4CEE7;
	Fri, 17 Oct 2025 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715596;
	bh=3LRvCAdJA1flSoPZchJ6I7GvKBCXO/DULXN7xkY0bVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQttGrSrAtbPomZz/CD0tjMbZLqhh6qCzKA3RCRVFMSSSOx8FLO907RpjPLKCI4Vm
	 l5UmukhV66/V/DOnsJdAzXWq0Gg+asEh40c2k2yZS19nL/Gg68WcmIm8AHDwuAQnu4
	 jDp3hE48hJUGfhulERaSOMKk/5hlsMuR22IM1rqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.17 238/371] of: unittest: Fix device reference count leak in of_unittest_pci_node_verify
Date: Fri, 17 Oct 2025 16:53:33 +0200
Message-ID: <20251017145210.691376277@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit a8de554774ae48efbe48ace79f8badae2daa2bf1 upstream.

In of_unittest_pci_node_verify(), when the add parameter is false,
device_find_any_child() obtains a reference to a child device. This
function implicitly calls get_device() to increment the device's
reference count before returning the pointer. However, the caller
fails to properly release this reference by calling put_device(),
leading to a device reference count leak. Add put_device() in the else
branch immediately after child_dev is no longer needed.

As the comment of device_find_any_child states: "NOTE: you will need
to drop the reference with put_device() after use".

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 26409dd04589 ("of: unittest: Add pci_dt_testdrv pci driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -4300,6 +4300,7 @@ static int of_unittest_pci_node_verify(s
 		unittest(!np, "Child device tree node is not removed\n");
 		child_dev = device_find_any_child(&pdev->dev);
 		unittest(!child_dev, "Child device is not removed\n");
+		put_device(child_dev);
 	}
 
 failed:


