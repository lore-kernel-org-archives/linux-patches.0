Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844C855E5E;
	Wed, 21 Feb 2024 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523870; cv=none; b=CNSEkdr+y+bcM+wbTjPujDkdOrtJD7zTEx2md+TFkJUaeeCG68fxWD5Ms4oaPKKyWhSDqSOMjIdeeaa/+2Ksne33dnrrIaLKrHZa2PIYNkO126ke62JlL0kVzJA0yq+3as4N2psOEJ7ozB/p1ClSnr2gf4gk4LwCpmcrxyNMkbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523870; c=relaxed/simple;
	bh=AnXqbMR4bxXBI5kD63OdJffRe89JYJ3uam7gAQueTOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY8xbguxnoD2NQ25ky1P97zH5kvCszoF+ecICfLpk+fI3jaFqLxOvLdqZzyZAi7xnjlbVtKDh9kNFwKuNpRIWmvG+wmOPDSN549+R1O7IVGfEnqiqlc1Lr45cNhI0tfCC8WvYC1nkc28l5ENvlQT3OtxM4vvGUtEOKNlSESkWzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd2W6sC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd2W6sC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D90C433F1;
	Wed, 21 Feb 2024 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523870;
	bh=AnXqbMR4bxXBI5kD63OdJffRe89JYJ3uam7gAQueTOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd2W6sC5FZFiL/doyyHvWg6dxWq5HrDKJOzTpFEStZ3xmPGaPKjJIHEpS9OujH8oN
	 eBbTCI17l85McTJPL2kSpH2QBTra8Vo7y3CJjA5hW4MKV3XvuWkv5nm6GWt4BfNXcT
	 klmXUGbq5W1v48N/kBqxWORfewHrXfxIKOsIabks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/379] PM: sleep: Use dev_printk() when possible
Date: Wed, 21 Feb 2024 14:04:16 +0100
Message-ID: <20240221125957.188260609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit eb23d91af55bc2369fe3f0aa6997e72eb20e16fe ]

Use dev_printk() when possible to make messages more consistent with other
device-related messages.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7839d0078e0d ("PM: sleep: Fix possible deadlocks in core system-wide PM code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 1dbaaddf540e..a4714a025315 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -16,6 +16,7 @@
  */
 
 #define pr_fmt(fmt) "PM: " fmt
+#define dev_fmt pr_fmt
 
 #include <linux/device.h>
 #include <linux/export.h>
@@ -449,8 +450,8 @@ static void pm_dev_dbg(struct device *dev, pm_message_t state, const char *info)
 static void pm_dev_err(struct device *dev, pm_message_t state, const char *info,
 			int error)
 {
-	pr_err("Device %s failed to %s%s: error %d\n",
-	       dev_name(dev), pm_verb(state.event), info, error);
+	dev_err(dev, "failed to %s%s: error %d\n", pm_verb(state.event), info,
+		error);
 }
 
 static void dpm_show_time(ktime_t starttime, pm_message_t state, int error,
@@ -1898,8 +1899,8 @@ int dpm_prepare(pm_message_t state)
 				error = 0;
 				continue;
 			}
-			pr_info("Device %s not prepared for power transition: code %d\n",
-				dev_name(dev), error);
+			dev_info(dev, "not prepared for power transition: code %d\n",
+				 error);
 			put_device(dev);
 			break;
 		}
-- 
2.43.0



