Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A813557F3;
	Fri,  7 Aug 2026 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115964; cv=none; b=jr0QjXsLQYwyRq9Pib7a4T+TBWa3tbzORscXLZMN+TRfP5rXdT4yedgzc0r80YAwd0imH77g+V4uotKkhuNrv6Oao/w2sfgM44Wf5/9xeG4aaik8JTH5wifWDdDQsi5fggjZPtR85KgE4+z6E1lQv+JXT9up6yW9RCm8mbENjAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115964; c=relaxed/simple;
	bh=osJl7iQpJhS94ZPYVZYDzFbGTXFfQGbnT2fn4U2nT24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWJko/a1PqPJm2020+2FWiXxAuY5t27vwBv6kBdcw1jeV41f/7bbGqXRmBtTrMFyoRm5UYFX1kkYRJHR69iW4Vs9dU5U84NDtMHlh0oBHWvQa0T4y14QnGIYxOOKz+k2SDm9hYHntnLNT6dCCLgTVrtpFdAYZUIzTvE/B+TQF9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPHj0Eg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPHj0Eg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B342B1F00A3E;
	Fri,  7 Aug 2026 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115963;
	bh=wu0pPJToV5Dj11g5TFop0paJPki2cMMyq8rGhfXinzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPHj0Eg/fsfitE1gFuoE6RRHdmqyp+NFcs9Jqg5TrjSy8Ox4DGDU+uCkxJfGZwiYx
	 AlgbFyHYcM10KEjBJXMlMCCj+SuQ4J/rCcxre+BBgqK0QO4QFs+2Stpy9t3r5Wsevk
	 nj0dxGG9MgAi84HoDGQJ5K7waWBR+mR0DDobWq4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/261] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Fri,  7 Aug 2026 16:36:59 +0200
Message-ID: <20260807143416.721792570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a19038a200f18d9e74ac30081797917d0886e16b ]

pmbus_update_byte_data() is supposed to return a negative error code or 0.
However, if no change is made to the register, it actually returns the
register value. This can result in problems if the calling code explicitly
expects to see an error code or 0.

Fix it to return 0 on success or the error code as expected.

Fixes: 11c119986f270 ("hwmon: (pmbus) add helpers for byte write and read modify write")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index eafeabfd93d77..2cf5f1fe8886c 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -449,7 +449,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, PMBUS);
 
-- 
2.53.0



