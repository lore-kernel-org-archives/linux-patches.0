Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086763E316C;
	Tue, 31 Mar 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974579; cv=none; b=R2QaLtkfE7OzKJI+pz5hoGOsEEXhlHy5Nlw1VdlP+PqF13Sj2TxWNz1NuFohkb3d97V9YLsv6PiQnSTEJBkxrWm2PXCkxeTP104BmkfqM7e5B1fIPAeZO+mLs/cW4O48DoTIaW4xZ3WhAlzxQMXKLt65IIz22tPI4nJsFOnpIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974579; c=relaxed/simple;
	bh=eg0lwXKZRqUXJDSdY2p2wKTKMGa6gP0MWW8/9IlKAw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j900PxTKXVbFtR/ImjL+RhJGDuHvzdFHx5I28kCUUijFezT/Dx9nNvB9KORW4SJcqJ9prmJEfRnG54Z6EClDLFZXaWnNsS/BKyDBT35QZFNMVWzzUZe9St/Rks9AMRbnZrouK6zanhPKJgVB/+mu0zV+6kumb6k8mDosivE3j6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xv4CLCSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xv4CLCSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58459C19423;
	Tue, 31 Mar 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974578;
	bh=eg0lwXKZRqUXJDSdY2p2wKTKMGa6gP0MWW8/9IlKAw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv4CLCSButd8OCycfP03VJWoyWXXxUG1ltBrrw6Pm4IJsdqEUSXHtQnH2rVnM1ji4
	 0criiG43Z6Vpt8VR949DGbKOAtOm1zVjCmjIHlYFo4GpUm3iomJl7h3uZNCs9FAEml
	 Dqqf2Dcy0XXu3sSXdRsnj16CfBaBEMoP8RZmpFmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 112/175] hwmon: (peci/cputemp) Fix off-by-one in cputemp_is_visible()
Date: Tue, 31 Mar 2026 18:21:36 +0200
Message-ID: <20260331161733.895005874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit b0c9d8ae71509f25690d57f2efddebf7f4b12194 upstream.

cputemp_is_visible() validates the channel index against
CPUTEMP_CHANNEL_NUMS, but currently uses '>' instead of '>='.
As a result, channel == CPUTEMP_CHANNEL_NUMS is not rejected even though
valid indices are 0 .. CPUTEMP_CHANNEL_NUMS - 1.

Fix the bounds check by using '>=' so invalid channel indices are
rejected before indexing the core bitmap.

Fixes: bf3608f338e9 ("hwmon: peci: Add cputemp driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260323002352.93417-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/peci/cputemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -339,7 +339,7 @@ static umode_t cputemp_is_visible(const
 {
 	const struct peci_cputemp *priv = data;
 
-	if (channel > CPUTEMP_CHANNEL_NUMS)
+	if (channel >= CPUTEMP_CHANNEL_NUMS)
 		return 0;
 
 	if (channel < channel_core)


