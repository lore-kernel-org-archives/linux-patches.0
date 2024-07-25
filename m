Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACD719D066;
	Thu, 25 Jul 2024 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918486; cv=none; b=nfmkBqFsSTp82YPxWBKZyHP9NyWmUUFoaehzcqjfbT6hepNcQpX4JUQjI4rRS5T7lufZ8X948mA/VGZQzqRWP/XGjMIGYv7umbVZc8nSRZ1XJIg7fsPrn649sR8UTrmq/HZ1j08aG/Wa7me6qOuR2hz0em9D25oM1OG45czALpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918486; c=relaxed/simple;
	bh=4IXjiRLO8OV4qS+L+ZZOF4LXXAdzY1MLAz5WvZtSKeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xa0qedPzom9HsfTQtnkIXOR8sFFg1l86CLPZEnzmUaVmr2hfouLvFXbEDuuii7LG88BjermpIiTEnTWnrgiGIcvIQBzycbZtMPsyypqgdKaIOt4u24aBwVpIKllavAD3vxjbK3jNNjuEIGOIlXWqTBcp1VNgjA1SCsL9GeboPgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sa02KSKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sa02KSKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5474C116B1;
	Thu, 25 Jul 2024 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918486;
	bh=4IXjiRLO8OV4qS+L+ZZOF4LXXAdzY1MLAz5WvZtSKeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sa02KSKQL75a+Y8yi8FmypSJKD01cMpkLcexOIiIsMIiCx9TfwZira1KcCt4kmFtz
	 S2wyg4Srs8RRYb+NoXKtdTXy+ogbCIW8/7XP0mwWyZ4LqUmyhzPKPbvV3qzMQ8qASm
	 fwreZjqr2BVLS4YpvX9YszIx0RsFrgqfgEvZR6hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/33] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Thu, 25 Jul 2024 16:36:27 +0200
Message-ID: <20240725142728.683946468@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c4bd7f1d78340e63de4d073fd3dbe5391e2996e5 ]

If an error code other than EINVAL, ENODEV or ETIME is returned
by acpi_ec_read() / acpi_ec_write(), then AE_OK is incorrectly
returned by acpi_ec_space_handler().

Fix this by only returning AE_OK on success, and return AE_ERROR
otherwise.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 78f8b8b5a8099..7db62dec2ee53 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1348,8 +1348,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 		return AE_NOT_FOUND;
 	case -ETIME:
 		return AE_TIME;
-	default:
+	case 0:
 		return AE_OK;
+	default:
+		return AE_ERROR;
 	}
 }
 
-- 
2.43.0



