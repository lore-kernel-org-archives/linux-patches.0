Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0291DDE9;
	Tue, 16 Jul 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145776; cv=none; b=E2RwFffRd/6j8SnEH+0ReWR7gyDFGtWHEj2S+pwjtf/c/lELCzZ1vLb+vCuy4hl94g0xvz4jaRB3rzJGfkMqr3HHcnk7LfWIPJekxkxn81jP+IxGk/Z7bkvAjaRMHDdQmWYAXVYma9aVDjQEKQnP796modKqL4ee/Jo1aQaY5sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145776; c=relaxed/simple;
	bh=Nd3lNedpHq8RP7aHZLS5fapR55IHVWhtnZM8v3KwhNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlF3jmjT0R5ki7MNFkbn/vHXDJwY09UfnwvjVPPRy5LIRl0PmCJZu6wJNY7VtJMtDhHTrzEmFqwjCzs1MBSXYeIv7uATATJyqdVV90KmPSv0xSwCNRQNVD8co3/Kp37OVpiugiOFCmNIbmFmBABVZVEeSg+aHTf1AwmpEmvJlgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXtTKhyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXtTKhyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65424C116B1;
	Tue, 16 Jul 2024 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145775;
	bh=Nd3lNedpHq8RP7aHZLS5fapR55IHVWhtnZM8v3KwhNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXtTKhyHayXbMFkyUgEUQakQqSnzNzI4415M/ChPGQiMmuqb2Es+xAL+nURhMmaJN
	 l4F64ytjHbjC8n4qfnfpbQyhFWYvFakIcH6eM0TwU9CJGKZO1x48OS/j8EE84NO68P
	 uw13XweXtQiaw5yV0sbkamDR8V8op3Q0IOp8S49w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 080/121] nvmem: meson-efuse: Fix return value of nvmem callbacks
Date: Tue, 16 Jul 2024 17:32:22 +0200
Message-ID: <20240716152754.406217896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Joy Chakraborty <joychakr@google.com>

commit 7a0a6d0a7c805f9380381f4deedffdf87b93f408 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

meson_efuse_read() and meson_efuse_write() call into
meson_sm_call_read() and meson_sm_call_write() respectively which return
the number of bytes read or written on success as per their api
description.

Fix to return error if meson_sm_call_read()/meson_sm_call_write()
returns an error else return 0.

Fixes: a29a63bdaf6f ("nvmem: meson-efuse: simplify read callback")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628113704.13742-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/meson-efuse.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/nvmem/meson-efuse.c
+++ b/drivers/nvmem/meson-efuse.c
@@ -18,18 +18,24 @@ static int meson_efuse_read(void *contex
 			    void *val, size_t bytes)
 {
 	struct meson_sm_firmware *fw = context;
+	int ret;
 
-	return meson_sm_call_read(fw, (u8 *)val, bytes, SM_EFUSE_READ, offset,
-				  bytes, 0, 0, 0);
+	ret = meson_sm_call_read(fw, (u8 *)val, bytes, SM_EFUSE_READ, offset,
+				 bytes, 0, 0, 0);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int meson_efuse_write(void *context, unsigned int offset,
 			     void *val, size_t bytes)
 {
 	struct meson_sm_firmware *fw = context;
+	int ret;
+
+	ret = meson_sm_call_write(fw, (u8 *)val, bytes, SM_EFUSE_WRITE, offset,
+				  bytes, 0, 0, 0);
 
-	return meson_sm_call_write(fw, (u8 *)val, bytes, SM_EFUSE_WRITE, offset,
-				   bytes, 0, 0, 0);
+	return ret < 0 ? ret : 0;
 }
 
 static const struct of_device_id meson_efuse_match[] = {


