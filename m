Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83C228DEEA;
	Wed, 23 Apr 2025 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422052; cv=none; b=m04DQzcet770Q1stIofm9a0ioHLmxb9Qzke398lfgXph5mvjsI8pLfOyaounp1Nm4/nozbvSlZFC1G/sPJe75kb8VFV1WPvXJUSlyAMmTRKtO7sOqyTVcKreyaHxdi9u9dYL5NpvcyJzgBNTsaDkk6iHaSKGN11FICZi6lyI3ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422052; c=relaxed/simple;
	bh=tonkvqmEJU035JKxUsDP2ZMBPeSyvE+4fZhmSLdBq+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lf+JbfvYJOSorvOgQh0US118CGeJzNRhARhR33LaWOGYkitjAC2HKg7hEQS0gX3P3wtrR61VSPfacLFpjPvroF4HVpi+tTdfOYLVU51hM6XIqIvozV21lG83kMuRCz5JGkTb/l/pBDHhNa+LFiFLqbmV8mdoBCCaKbn+i5hA+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DriiBlhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DriiBlhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA0C4CEE2;
	Wed, 23 Apr 2025 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422052;
	bh=tonkvqmEJU035JKxUsDP2ZMBPeSyvE+4fZhmSLdBq+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DriiBlhz/QYmkpmmIjDtObQssNNjjB1rB5cjjKBJTQNFwQLEShWWV4i5F1++XKQko
	 95UXl97q9qHekq1g+7j3ESIs7LibMcipfUBIr+QG7u1mg0zznpYuQy+KkW0+qSPZCg
	 /Uciu/ktobbV01eAMdJB2ZQk4r1fF/Fk9F/KzT+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/393] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Wed, 23 Apr 2025 16:42:32 +0200
Message-ID: <20250423142653.948154001@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 324dddea321078a6eeb535c2bff5257be74c9799 ]

The btrtl_initialize() function checks that rtl_load_file() either
had an error or it loaded a zero length file.  However, if it loaded
a zero length file then the error code is not set correctly.  It
results in an error pointer vs NULL bug, followed by a NULL pointer
dereference.  This was detected by Smatch:

drivers/bluetooth/btrtl.c:592 btrtl_initialize() warn: passing zero to 'ERR_PTR'

Fixes: 26503ad25de8 ("Bluetooth: btrtl: split the device initialization into smaller parts")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 1e7c1f9db9e4b..7f67e460f7f49 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1194,6 +1194,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 			rtl_dev_err(hdev, "mandatory config file %s not found",
 				    btrtl_dev->ic_info->cfg_name);
 			ret = btrtl_dev->cfg_len;
+			if (!ret)
+				ret = -EINVAL;
 			goto err_free;
 		}
 	}
-- 
2.39.5



