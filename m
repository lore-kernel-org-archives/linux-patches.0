Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779F119D074;
	Thu, 25 Jul 2024 14:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918530; cv=none; b=IOS1zmrjCAK0/V+C6OdDBxoAHdHGvCoaG70L+o9ljMwdRV+9Sig/AxGUIIKNtxzelDAoMMRX262Zyy9qfRe1Na4B+n93hNvdYM8W6wRn8JA3T2YjBbGeQj1cGwCP0M52KIR0LyTYwdp9D+EYe+K/Ye5HivK/IrMVbEpIVtbXrp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918530; c=relaxed/simple;
	bh=nxEgAg2KnHoDYujPejg4jK4pXPUaePiQAk8o/HIFZeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaQZOTTa9dax57oVmHP+upm7y72J26JH5EIQvWHMSNzPveyH4T0gRpNJblLvRoBRnmF3jvhFRPgHLqMGyvwsx5tOfNlMIr6jb3tRMjwx4WqClW5+vG3eHClRKN6DdIxfKpU9ylYTXB78pKjdkwlNLgYYkTJ35b5xKHU3aUdWAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CumEW2xU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CumEW2xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018ECC116B1;
	Thu, 25 Jul 2024 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918530;
	bh=nxEgAg2KnHoDYujPejg4jK4pXPUaePiQAk8o/HIFZeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CumEW2xUyQyq3ZUrKu1/PhdOiSJ0qv7CHVddJZDD4pYR8RjxzRrm4E5HSRusY1kRQ
	 pzZd86oB2/voOk/+gWrULnubsimoaN9O943MY5ZTb+fc0p47Lsuq4keAffrnPpT1Z7
	 k3hyvO6yVqCCLisGLIMBhVC9S+Lk4yeM3ysxZCHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/43] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Thu, 25 Jul 2024 16:36:28 +0200
Message-ID: <20240725142730.678531455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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
index 43a8941b6743d..142578451e381 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1328,8 +1328,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



