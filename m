Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B254178381;
	Tue,  2 Jul 2024 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939960; cv=none; b=F/X3QNRJ4Id500TRMuIZZQdpgxGsceRSNXHRhK1CRYXBYj/mEz+/vrJLOP2MS9sba0flqDQdDLqoam+YwYV0shfow1tSKShEyaAimbNPzUoaU0yjoRf+AlXYFYS9Pc7T/v5GJAGBPgftGMlZQqnO+PHM4EgJEhZZ3ppW9sCzzKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939960; c=relaxed/simple;
	bh=3IcMwHeaShhNPdg+eQrthwkS8Xkz+lTFWc86seztjdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oD6TScn8r5SGNvYeBJAdpnb5iSvfKJL2rfWsm2L+nuEL0ZZqNqIU2tLMyAAMZKfUsYeZ2WG+bidjUl7mcushRhvygHcBl6/nejvzrrsjYBRNrRvrA8uJPN0Bqr+ZzCAKgbR3JXjPyBVm2C8+WkWf68idB+GKImiDNzDgh+HgU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj3t/l+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj3t/l+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA06C4AF0A;
	Tue,  2 Jul 2024 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939959;
	bh=3IcMwHeaShhNPdg+eQrthwkS8Xkz+lTFWc86seztjdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj3t/l+HnoCnc8AF139T1LVVJosWPK5jZhNSmy0AEZSupGW06kOgs7Mk6ik3BPCSX
	 h1SSEXUqLzfMUkQ2t4BRY/UXVfnQBBQxapPTxCBgeyWQuNV6r073yf5n8e9dRZ1Bm3
	 MQEDjP4r2BfcYWjqSxeQxEclwSdRLVDuTKcRdK2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ammy Yi <ammy.yi@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 002/222] usb: typec: ucsi: Ack also failed Get Error commands
Date: Tue,  2 Jul 2024 19:00:40 +0200
Message-ID: <20240702170244.060769948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 8bdf8a42bca4f47646fd105a387ab6926948c7f1 ]

It is possible that also the GET_ERROR command fails. If
that happens, the command completion still needs to be
acknowledged. Otherwise the interface will be stuck until
it's reset.

Reported-by: Ammy Yi <ammy.yi@intel.com>
Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240531104653.1303519-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 144e47ed6fae3..911d774c9805a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -153,8 +153,13 @@ static int ucsi_exec_command(struct ucsi *ucsi, u64 cmd)
 	}
 
 	if (cci & UCSI_CCI_ERROR) {
-		if (cmd == UCSI_GET_ERROR_STATUS)
+		if (cmd == UCSI_GET_ERROR_STATUS) {
+			ret = ucsi_acknowledge(ucsi, false);
+			if (ret)
+				return ret;
+
 			return -EIO;
+		}
 		return ucsi_read_error(ucsi);
 	}
 
-- 
2.43.0



