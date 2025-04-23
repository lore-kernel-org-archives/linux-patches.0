Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7F028F924;
	Wed, 23 Apr 2025 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420908; cv=none; b=Dl3l8PcFKNyGTrK7CqMY8HQ8q1K0Um+T/Bm8P2zF+yk3GkolMHV5uXrHa81orxOVX6FLIWCVckL3PdgU9OWetccN75X6XL25As6RhmToKf10GQOuhNCyY928BpFUOfv6AP80bGZ7u6J/mTkdDtb6jHhb04rydQlgyP7wXDxyl80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420908; c=relaxed/simple;
	bh=uzrUZ1H+mU/JfzwBOmCsFBy5lAtBK7Sm6w3bifIFfNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMZOlIH/XCT2BkJCXhAVpTN5stgmcktFUu3KURhDk7l+KiqNsC0X/X+qPl3O3utxwAbalcWr9iBA3X9ORpEfPjOpSvEYWKLn8EoGhGEX/Oq1DQd/4AHH73f9JG88/R27QjJ96aGwj/QbFp3pd6mx0y7RpAQ46MFPDUNXdD4O6Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXuJKaEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXuJKaEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBEFC4CEE3;
	Wed, 23 Apr 2025 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420908;
	bh=uzrUZ1H+mU/JfzwBOmCsFBy5lAtBK7Sm6w3bifIFfNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXuJKaECqWsnqERKfm84NnMfroi8t+PgasVy482rK3naxVyby8IkOZenqjg6cgk0M
	 EWA+9RVqJ9vysYqWXJclQjuy8UCiEi8DiJ9QdM1vE8lVB++N3/Ul10FJE9gxW2i1tN
	 nQbs924PH8xwTOCh74CpnysXOceRSZMaUWeruJT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 126/393] media: siano: Fix error handling in smsdvb_module_init()
Date: Wed, 23 Apr 2025 16:40:22 +0200
Message-ID: <20250423142648.564458082@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

commit 734ac57e47b3bdd140a1119e2c4e8e6f8ef8b33d upstream.

The smsdvb_module_init() returns without checking the retval from
smscore_register_hotplug().
If the smscore_register_hotplug() failed, the module failed to install,
leaving the smsdvb_debugfs not unregistered.

Fixes: 3f6b87cff66b ("[media] siano: allow showing the complete statistics via debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/siano/smsdvb-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1243,6 +1243,8 @@ static int __init smsdvb_module_init(voi
 	smsdvb_debugfs_register();
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
+	if (rc)
+		smsdvb_debugfs_unregister();
 
 	pr_debug("\n");
 


