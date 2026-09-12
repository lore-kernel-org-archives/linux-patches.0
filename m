Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D792336886;
	Sat, 12 Sep 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221370; cv=none; b=oZuDticUMzpvKlmKxjfCR/NbD3Sra7Ana/Lzm8b7j4UOdWDobAAYrIZouh1qWKvlxBgCFa5pCc5RFZa/Yxt5ffmU6u2XKV+hgXSckrccPim3FxVuCYrMBhCDHQEg5Z8IzRpJildYj6XU1UVpx4IQaXvxr2M6HaWvAhAkHwekGOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221370; c=relaxed/simple;
	bh=eCmKN+wG91hTt5vY8YgxsOaG0DEB9PbvM5MIDfVUEe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHh4pJNszh2qPAATpn1nOqR4SPjFyz1uvPBbhyQTbgDESxjPcVH5bp9THaYcjd8qT3M5Wusb+MpJzCC6vcBRywvaPX0pqzI32Bbi0OVsHbyRKUdrNKMAbpJqPbMWRj1bV9NgVQLK/88VIcU7YWwrlpTgLJ6Nq74UGdeqt+3OuFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B62lgPFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B62lgPFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDE11F00898;
	Sat, 12 Sep 2026 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221366;
	bh=NHF1bII+/QDAZLFaIgVbKc7df6h9FUoWLkV7Iot4xDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B62lgPFzLf3/sTNMF51C/jFsGsEvjBdNWI18UeyDESK0P5XpnpBKlYlpnEB9+fImL
	 lX3mPArYIbtgvCBUgu+ZgZyt1B274K9nx53RiG/th/BmoL//CIomgrrkYcJIEqqLZq
	 ryzXOamoztRsxhkNgNBGDk3EXDrFywyVzOCvIrac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Byagowi <ahmadexp@gmail.com>,
	Peter Rosin <peda@lysator.liu.se>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0368/1424] i2c: mux: Fix channel node leak on adapter add failure
Date: Sat, 12 Sep 2026 08:46:40 +0200
Message-ID: <20260912065615.533798481@linuxfoundation.org>
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

From: Ahmad Byagowi <ahmadexp@gmail.com>

commit 385c7af4e3b95d0769fd211831674e83b16a2ebf upstream.

i2c_mux_add_adapter() takes a reference to the Device Tree channel node
before registering the new adapter. If adapter registration fails, the
error path frees the private data without dropping that reference.

Release the channel node before freeing the private data.

Fixes: bc45449b1444 ("i2c/of: Automatically populate i2c mux busses from device tree data.")
Signed-off-by: Ahmad Byagowi <ahmadexp@gmail.com>
Cc: <stable@vger.kernel.org> # v3.5+
Acked-by: Peter Rosin <peda@lysator.liu.se>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/b3e46bbee781b3cb4029aca9a71316cc5e36dc17.1787502619.git.ahmadexp@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-mux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -433,6 +433,7 @@ int i2c_mux_add_adapter(struct i2c_mux_c
 	return 0;
 
 err_free_priv:
+	of_node_put(priv->adap.dev.of_node);
 	kfree(priv);
 	return ret;
 }


