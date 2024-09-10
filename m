Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB07581D;
	Tue, 10 Sep 2024 10:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964341; cv=none; b=sdj9tZgg99hgaSki4E+1mduegL6RxjFqrKDJntd7sV58NjbW6tkjIP3SBkHRMc+SRu5AfwR/C34iC8u5zAtraFGZXswSwNyXsv4varR6U/4hTh1IdyOSILL4ROt18q+kujWyukqbYQvhV9VhVHcAuXsjorTxYspHqtO5JO1rshI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964341; c=relaxed/simple;
	bh=/tNEC6dWs9w4qbISY4/pRT2RKGc6UK70mT6C6xQUAjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldpZSKi0avg+ZQpxpZ0hnV2gkYTkPKANITd3S408dQrr9gzbAGFbI4FyWtwwVG2M4drowctOOI+wEEQsL8SGc9GkyxDCxiEenGbkbqAP7Gb0c6E1swUzDbrQA1+zW/4YI0+xuPeoylyNlLlq5FFI1gcCtDSKL3x8kEONq6grX2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5T8P291; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5T8P291"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F321C4CEC3;
	Tue, 10 Sep 2024 10:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964341;
	bh=/tNEC6dWs9w4qbISY4/pRT2RKGc6UK70mT6C6xQUAjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5T8P291b/tVuG7PsOgRMRZM9ENDaHS00r5GE1wiPYTniOM9Fc9JmTyf9Gilhz2Xn
	 oTX/NqBUjZQKRgAVeuY24fimolse0lqhfK79RqVaI06AZFjAy7hYeMNU+uWcvMWX/w
	 aU9gg3jmePKJ4LLmpOj7H4gx9GxJaIQZLjiT0TD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/269] net: phy: Fix missing of_node_put() for leds
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092612.523898755@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 2560db6ede1aaf162a73b2df43e0b6c5ed8819f7 ]

The call of of_get_child_by_name() will cause refcount incremented
for leds, if it succeeds, it should call of_node_put() to decrease
it, fix it.

Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240830022025.610844-1-ruanjinjie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c895cd178e6a..2e4bff6055e2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3164,11 +3164,13 @@ static int of_phy_leds(struct phy_device *phydev)
 		err = of_phy_led(phydev, led);
 		if (err) {
 			of_node_put(led);
+			of_node_put(leds);
 			phy_leds_unregister(phydev);
 			return err;
 		}
 	}
 
+	of_node_put(leds);
 	return 0;
 }
 
-- 
2.43.0



