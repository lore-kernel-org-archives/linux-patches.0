Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C397F2F28F0;
	Fri, 21 Nov 2025 13:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732163; cv=none; b=ljIGIf5ZPZDeIFC4u81lb9AlVtUVWKFzlvNCvC8DWnIej6mHulpYblgYgcuoP2rBKyCoWZ0GiDfnrzaJJ269ruuOeArt7ZOm/I4e+7mWOTVkVKoFSs1uNP3ApAkCJjHMbXgEVV9uF1thHHTf7v5/6W6Rm8fd0MLtJe7fdYp2WOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732163; c=relaxed/simple;
	bh=E9rOGcPXsaU9aapr2eMKtex71l4zjlx1s02QfdBApBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZBZLH8nWHVhINGyapdpGZjWY6IHdC1RutYP21dxP3zhb2iRaRTgCSqrReCrDPw/bLcWbFS2D3oIqW1Tgx/+OKkslbqAGYFJsFfjDr9dLLBWj1EX7HP5e0/2DtUAGSJgEfmg4I27M5Pan4I3zhe2svm0vsAefwyTT8vI3I6DXJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJgbekXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJgbekXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477A2C4CEF1;
	Fri, 21 Nov 2025 13:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732163;
	bh=E9rOGcPXsaU9aapr2eMKtex71l4zjlx1s02QfdBApBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJgbekXD3dJswY9hHGbal5WN0cKHDL/xgajEMxuASG/Wl9V3j2oquGz2LLAVxeZuq
	 fCORENjmHeHhIi+4uWD8h0KkRbC7O/4sRt4ywgWO0Sbo15efvknC1PYlVG2/0H9vsW
	 sDAa628Wkiu0kmZUrsrYgIMb1GbzmSsJ60MFfLow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 006/529] ACPI: button: Call input_free_device() on failing input device registration
Date: Fri, 21 Nov 2025 14:05:05 +0100
Message-ID: <20251121130231.222910259@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 20594cd104abaaabb676c7a2915b150ae5ff093d upstream.

Make acpi_button_add() call input_free_device() when
input_register_device() fails as required according to the
documentation of the latter.

Fixes: 0d51157dfaac ("ACPI: button: Eliminate the driver notify callback")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
[ rjw: Subject and changelog rewrite, Fixes: tag ]
Link: https://patch.msgid.link/20251006084706.971855-1-kaushlendra.kumar@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/button.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -603,8 +603,10 @@ static int acpi_button_add(struct acpi_d
 
 	input_set_drvdata(input, device);
 	error = input_register_device(input);
-	if (error)
+	if (error) {
+		input_free_device(input);
 		goto err_remove_fs;
+	}
 
 	switch (device->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:


