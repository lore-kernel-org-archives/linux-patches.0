Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F4D340D9D;
	Sat, 12 Sep 2026 14:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222827; cv=none; b=bSJ8SWcpwCmXAmo/zIZAzAGpCD2OeSUqhGUTye8yca30WjIJ+xy0AuX+7jimtaixuIekNEOVPki6vCslNJlHX8RJRuMmWxOANTR/rSIU/E03IdEgzcC8AwCKx+uysFAWIvamkFBLUlKKXoNE9RpG/4lPIM0Mi5ktAWhOW6vxyD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222827; c=relaxed/simple;
	bh=WIyxgwkA/hvYEoTBwX+PfdvdKcC8GWdrFv3dygWlgYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyQi9fGnJkZym+PpxZrzdTZkZtXSM9Sjj0gyzixAMvQzs7d+rbJ1yQMFn9jrHKMKXsAaHTsfyYL6S4ZAdnLzQXxXqsZxRiHOb/hmNphtwFscDChS2W6RwLtanfldtmFXHwS9yy5jW5B4QIs1oeF9oVinhYt4Ez4Aa44R5r4F1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1Dq+kIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1Dq+kIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441041F000FF;
	Sat, 12 Sep 2026 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222826;
	bh=AtAcFegCb9EahTW4LvGTW/FPfnkqE7upE4zFmQXGDeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1Dq+kIe0ihwLCX4Gs/IsLEHe9sZANP96sGa86olN8vkDGmqQKUnhbOfsOhvw7PFu
	 /I3h1zQd4x47utHcDWmaN5SwY1cVJ7/OmuR28cKFEjsIYEo9UNOSHLBO8eITZ09/I7
	 fGbXbHmsceLTFtHI31the5ldDGiKvPmwSSKh25L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0664/1424] staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:51:36 +0200
Message-ID: <20260912065622.164134098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit c0a9a8586a63fda49e61a6b83360feac2a60d898 ]

cvm_oct_rx_shutdown calls free_irq and netif_napi_del without
disabling the napi instance first. As the free_irq only waits
for completion of hard interrupt handlers, the napi poll
function could still be active. If cvm_oct_remove proceeds to
free the plat structure (which holds the NAPI instances), the
active poll function will access freed memory, resulting in a
use-after-free crash.

Fixes: 3368c784bcf7 ("Staging: Octeon Ethernet: Convert to NAPI.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260511150931.93382-1-ayushmukkanwar%40gmail.com
Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260615172734.42038-2-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index cd36b5ba6f6c2..3e9d58d321560 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,6 +535,8 @@ void cvm_oct_rx_shutdown(struct platform_device *pdev)
 		else
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
+		napi_disable(&plat->rx_group[i].napi);
+
 		/* Free the interrupt handler */
 		free_irq(plat->rx_group[i].irq, &plat->rx_group[i].napi);
 
-- 
2.53.0



