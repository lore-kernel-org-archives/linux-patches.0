Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1253A1E895;
	Thu, 25 Jul 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918880; cv=none; b=kjJYLRTFHKlpvJUA6a7AdqffbZh41XnSEoJWIGTFfkEx4FqA61YwcW4s/2H/921O2niW1RDT5L+tnqTZNwIx81QRRl1rlBOLuw1Q86Hdv519a+U5DbvnuQ6dUIodimqn74SvPVVEhzRen7bNVEm+5aBPKYYIbIAN4aJ/wObcUVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918880; c=relaxed/simple;
	bh=Gapd9Qt0rUOeNlGdv4lheTZOZvhakcASdA9lfj+e0Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow0PWrnBEU6QvSrQbQJNsTH3HDFoUDfdUI8trGRmnPOnAsCvk+Vn/3XwNQvS5Jl9tMjTL2Qlt/iyF9iGhHvPcbFvZraGQj+AJAK4oOQO1EcykGgQ8l54oHGqdvpzeSoR8aFdrzbpKL24wTW7sFPs/qXtdfjpd9XR+g2lHHCHLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocuA/1mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocuA/1mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3951EC116B1;
	Thu, 25 Jul 2024 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918879;
	bh=Gapd9Qt0rUOeNlGdv4lheTZOZvhakcASdA9lfj+e0Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocuA/1mm36DtUfLGcHra94U+iPlSgPdzbySTfUQrT4pKyDidmfpIVhsErHcEZF0oh
	 VPVhfI6tf5TUKSOqhPclTPwvK41sTE3G5Hw5yxxTiqlxYB/1yOTnsqB9UYYZYNHQTg
	 iDGO8m0kSTYtPXfPvY64AsgBgz7O5+E8KZBZywR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/59] mei: demote client disconnect warning on suspend to debug
Date: Thu, 25 Jul 2024 16:37:07 +0200
Message-ID: <20240725142733.915332783@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 1db5322b7e6b58e1b304ce69a50e9dca798ca95b ]

Change level for the "not connected" client message in the write
callback from error to debug.

The MEI driver currently disconnects all clients upon system suspend.
This behavior is by design and user-space applications with
open connections before the suspend are expected to handle errors upon
resume, by reopening their handles, reconnecting,
and retrying their operations.

However, the current driver implementation logs an error message every
time a write operation is attempted on a disconnected client.
Since this is a normal and expected flow after system resume
logging this as an error can be misleading.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240530091415.725247-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 9f6682033ed7e..d8311d41f0a7b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -329,7 +329,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



