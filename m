Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD532C929;
	Fri, 17 Oct 2025 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714447; cv=none; b=u1C+wSzU9DeSNaPkXyrO5n/PPHQPZms05Hl5ueWVmP5g+Tq30EAcGXEgWDaZJyvfzJDNBfskdV2FZtZUqlZuAPCLhSXKri0YcuuDh/EftozObHROZio3M8Et/l2G/bfPBBUNXWCHUx0NRLyGF55ogRsKWsqdy/bZ+DRMJQWkIRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714447; c=relaxed/simple;
	bh=mtmEA/s9YJYQSldrLN/aw2x7mpH10CMvoXwnDX0Wksc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMd8jWmO+vOONtERuFVANpe4Ax+wcrdq0avXBvUKINWVlXunJDtY6gf24L5tz0xgDDABI/cmqT/fTXYRXm4yS1Ljy07PGiDBprsCiuEfGTqB7nvblAYtpL5Uj9q+5vOrD4HE5Tp/vwGLVXiJbmFV1bIFsXyfFZo2mZ1VPe1/GCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQ1MXEp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQ1MXEp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882F9C4CEE7;
	Fri, 17 Oct 2025 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714447;
	bh=mtmEA/s9YJYQSldrLN/aw2x7mpH10CMvoXwnDX0Wksc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQ1MXEp+OSzDwMjdrPUW+Lakccmt80wG8W74HWQzlE6wfST/oK5VUhRZxul0i1k//
	 Tv1qP5wdC4GySaMGTIHQUA5GoOYABrYEl9l14JLzBvSdmHGAov3XshvQke+v9gTwiJ
	 ejpAUtQmm6qXfg9dyPIPWDhotpljnlhd7QfIkeDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 149/277] of: unittest: Fix device reference count leak in of_unittest_pci_node_verify
Date: Fri, 17 Oct 2025 16:52:36 +0200
Message-ID: <20251017145152.564633211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4191,6 +4191,7 @@ static int of_unittest_pci_node_verify(s
 		unittest(!np, "Child device tree node is not removed\n");
 		child_dev = device_find_any_child(&pdev->dev);
 		unittest(!child_dev, "Child device is not removed\n");
+		put_device(child_dev);
 	}
 
 failed:


