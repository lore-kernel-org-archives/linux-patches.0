Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623649;
	b=uzFWMUSK/qEumLYZzJoYaU0R5CsoeO9P3mDYHDp1MADWcxVNtb8y+Wcw/3qpGuvMPCVu
	 /1qaOOZ58nJfs4QbD9VN8XEF+Det6yTGuG9Q9LUjyX8i13bPTc8XJtQolrl1cz0mQc4dv
	 AHVPqzdeHu3BSGSA/jAm0SmKfgVng3dDdpJzbYYfI+7YBJmxBgR7rRsmR3XyRYiyDF5j+
	 c9+PqG7K3JwgQamSfh04c8R1v3Dtuy5Y04qiWZyipX1ae9nT5krJ1y+ZTUFnVJaxzo/Tz
	 UCW/xcSPNV9LSoFzQ0L4iT0bf2GQsB+qScoVPfHa2UbrnUMCzh/6Y3YEtYaZ1Wmkbpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eq7h9YzUW0+9/cM9XmyXujfTVAnHPjM87ipMpRu06xc=;
	b=eXlhwuMawc0ySrWI9Gdes1CcCoyUBO8KZyw5jU2tEF0jHsfslvW9fE0/sfLnLCgtbbXT
	 EZn1ZGTgZMweTPhncO6OMXDGD+e2ZC0eoNR1zShMUzHDgEEjZLXMon/Morp4x/S75TIYu
	 7kyjuaM2QmquXcuvKTmr94ZwOrGSX+5fkh2SE/Z1T9HPUi0VGPUZRRaEg+4lpEEcr3jDM
	 JZhAqpfNpQL4lXa7sYC5PFDMf5dMCEL05Kq90wR1gDjTmUAgxWCBnTNjljXHKqAqqTAHz
	 iV4UA5HSntF+MXee6pwZ+Qh5LDkbGg56ww6Ivt2EkB3bH87+DOGDm5i377AjCAaG9ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1z7n/fqh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6F7606A33F;
	Wed, 25 Nov 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1z7n/fqh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB911F000CA;
	Wed, 25 Nov 2026 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623648;
	bh=eq7h9YzUW0+9/cM9XmyXujfTVAnHPjM87ipMpRu06xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1z7n/fqhdroRUroHywXG1GsT0+OrOn4mJhr0/pMOBSx2qcvanaO9ozVISfzVljpGV
	 i7TVdFXauiMe81nobRLJwlAIgVrGwSQiiYjC+S8SUDpZJcT7XFNgnsidkJSguBA3/0
	 5MXXJ5KzragFtTlMpzhPb0mVCkrfidGv82GQuogY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.18 925/990] w1: ds2805: use the bus mutex to talk on the bus
Date: Wed, 25 Nov 2026 15:38:12 +0100
Message-ID: <20261125143843.667743122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit a2e52ccce044e13d2695bb1bbdc07942727f28dd upstream.

Since commit b02f8bede217 ("W1: split master mutex to avoid deadlocks.")
the slave drivers serialise their accesses to the bus with bus_mutex.
This driver takes the mutex of the master in the callbacks of its eeprom
file instead.

That mutex is held while a slave which has disappeared from the bus is
removed, which waits for the sysfs callbacks of the slave to return.  A
callback which is waiting for the mutex at that moment never does: both
tasks are stuck, and with them the thread of the bus master.

Besides, it does not keep the other slave drivers off the bus, so that two
transactions can get mixed up on the wire.

Fixes: f6887531c0c6 ("drivers: w1: Add 1w slave driver for DS28E05 EEPROM")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-5-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2805.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/w1/slaves/w1_ds2805.c
+++ b/drivers/w1/slaves/w1_ds2805.c
@@ -102,7 +102,7 @@ static ssize_t w1_f0d_read_bin(struct fi
 	if (count == 0)
 		return 0;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* read directly from the EEPROM in chunks of W1_F0D_READ_MAXLEN */
 	while (todo > 0) {
@@ -123,7 +123,7 @@ static ssize_t w1_f0d_read_bin(struct fi
 		off += W1_F0D_READ_MAXLEN;
 	}
 
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }
@@ -211,7 +211,7 @@ static ssize_t w1_f0d_write_bin(struct f
 	if (count == 0)
 		return 0;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 
 	/* Can only write data in blocks of the size of the scratchpad */
 	addr = off;
@@ -256,7 +256,7 @@ static ssize_t w1_f0d_write_bin(struct f
 	}
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 
 	return count;
 }


