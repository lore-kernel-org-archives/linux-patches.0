Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F59A31E0F2;
	Mon, 27 Oct 2025 19:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593058; cv=none; b=ozt0B7TEvviJtHvjVZ9s3PvQ8QUR1KsoDUTDcssHu3prn/vYl2FW8TBzbj4huMVrJoHpYgrw+H2Insmy3Qogzzlc3LVARmPSvAi6/EIhKqpazZdytgnFR+5dP2Rhj6mOsgeWS6sYMIzPg/o0/24iLZdgJxWlPgGrWJHm9g74luM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593058; c=relaxed/simple;
	bh=SQp7zspBKEhne3YoSb8otKVs1Cpc3Xf7C9Nf1SzPsNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh+eMKUm9W9WbZqooQuhffqMUPqoym4PnlyuZefSbGc7mu1LN6rlzTzfCTIUBYl4Mk6nbi+NcsksaSHR6YiMf0Dk3xTUfIpja5j0cpCe0hCwgOK5UTzOEWkPDYune1tphOApZ63WySIhXukZtfTNwLwxnq7fqqJ89xYEK/Ps2ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUO8bfJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUO8bfJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66759C4CEF1;
	Mon, 27 Oct 2025 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593056;
	bh=SQp7zspBKEhne3YoSb8otKVs1Cpc3Xf7C9Nf1SzPsNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUO8bfJUJ47POnfWTLydqCfYq5qbgIbh5DSyQTIYqqkuEeascAwAMZISt+xgeyQLq
	 fVYFSsCpqKFCfSIwv7FmrA8A44mNibmqVnIw8JsLvsIATB4Z+5FilVVKCsbls0pFRN
	 OkuNlZd7xDNXetpwZdhoPQ/RcMPoZl6XlV4ENSeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Junhao Xie <bigfoot@radxa.com>,
	Xilin Wu <sophon@radxa.com>
Subject: [PATCH 6.12 106/117] misc: fastrpc: Fix dma_buf object leak in fastrpc_map_lookup
Date: Mon, 27 Oct 2025 19:37:12 +0100
Message-ID: <20251027183456.890989458@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Junhao Xie <bigfoot@radxa.com>

commit fff111bf45cbeeb659324316d68554e35d350092 upstream.

In fastrpc_map_lookup, dma_buf_get is called to obtain a reference to
the dma_buf for comparison purposes. However, this reference is never
released when the function returns, leading to a dma_buf memory leak.

Fix this by adding dma_buf_put before returning from the function,
ensuring that the temporarily acquired reference is properly released
regardless of whether a matching map is found.

Fixes: 9031626ade38 ("misc: fastrpc: Fix fastrpc_map_lookup operation")
Cc: stable@kernel.org
Signed-off-by: Junhao Xie <bigfoot@radxa.com>
Tested-by: Xilin Wu <sophon@radxa.com>
Link: https://lore.kernel.org/stable/48B368FB4C7007A7%2B20251017083906.3259343-1-bigfoot%40radxa.com
Link: https://patch.msgid.link/48B368FB4C7007A7+20251017083906.3259343-1-bigfoot@radxa.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -384,6 +384,8 @@ static int fastrpc_map_lookup(struct fas
 	}
 	spin_unlock(&fl->lock);
 
+	dma_buf_put(buf);
+
 	return ret;
 }
 


