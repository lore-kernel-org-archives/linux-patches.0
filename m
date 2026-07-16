Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC875A79B;
	Thu, 16 Jul 2026 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210735; cv=none; b=PtvxGI9XQMZXpBJRe2aVSMSBZFfjrhAJjR6bo8EeMadpeOCfY66zRrE/7vfkjzamqZdV/6LagS1LvdMaZi3TNylLpt2yYm3Zptgil6QnflLKL/ZlWDcWFEeJWWskQVZERANponnGB9aeDOKeOlsaR1/gk2mfQdVUVTifgmQWRus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210735; c=relaxed/simple;
	bh=ird5YUwRUty1rXto9MAsk3u3No9L2RNNqlUcrQwv0bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPltIZCcBCDfr+LY/7YSkR70hRjye9fNiR1uYqtMZRaXBRUgmae9XGYL4KoJiLyOxRA7bM3RT0ATpujRP3s/OaUSi0tiTFMhLkNJM2nmohX2ez/Hyf27HQMTljgh+QN6VxFktsVUr6Azlr8XxHUQJL/LlhCeGkWrunAt06r7lDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYbWhfU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYbWhfU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5B81F00A3A;
	Thu, 16 Jul 2026 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210734;
	bh=uvioU4OD27ULTz4831jeUMORPGaNTBjsJuF0JYsYWQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYbWhfU6WujFmgG8Ly7uEsmkMohLrxUBJKLEouWq5/dhcHpJso1amHRZWSXdY7YlU
	 bGfuMfzZhjTIEBYi+IejO3UOsK4bGa4m8OP4gdoDtajxQeedinPNhFdZUJ6CB7//62
	 xmqlchzIJXJJj/8oJAY+3MjHSljfOjmv1bUwyu2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 160/480] staging: media: atomisp: reduce load_primary_binaries() stack usage
Date: Thu, 16 Jul 2026 15:28:27 +0200
Message-ID: <20260716133048.170948670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit f4d51e55dd47ef467fbe37d8575e20eee41b092d upstream.

The load_primary_binaries() function is overly complex and has som large
variables on the stack, which can cause warnings depending on CONFIG_FRAME_WARN
setting:

drivers/staging/media/atomisp/pci/sh_css.c: In function 'load_primary_binaries':
drivers/staging/media/atomisp/pci/sh_css.c:5260:1: error: the frame size of 1560 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

Half of the stack usage is for the prim_descr[] array, but only one
member of the array is used at any given time.

Reduce the stack usage by turning the array into a single structure.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -5021,7 +5021,6 @@ static int load_primary_binaries(
 	struct ia_css_capture_settings *mycs;
 	unsigned int i;
 	bool need_extra_yuv_scaler = false;
-	struct ia_css_binary_descr prim_descr[MAX_NUM_PRIMARY_STAGES];
 
 	IA_CSS_ENTER_PRIVATE("");
 	assert(pipe);
@@ -5191,15 +5190,16 @@ static int load_primary_binaries(
 
 	/* Primary */
 	for (i = 0; i < mycs->num_primary_stage; i++) {
+		struct ia_css_binary_descr prim_descr;
 		struct ia_css_frame_info *local_vf_info = NULL;
 
 		if (pipe->enable_viewfinder[IA_CSS_PIPE_OUTPUT_STAGE_0] &&
 		    (i == mycs->num_primary_stage - 1))
 			local_vf_info = &vf_info;
-		ia_css_pipe_get_primary_binarydesc(pipe, &prim_descr[i],
+		ia_css_pipe_get_primary_binarydesc(pipe, &prim_descr,
 						   &prim_in_info, &prim_out_info,
 						   local_vf_info, i);
-		err = ia_css_binary_find(&prim_descr[i], &mycs->primary_binary[i]);
+		err = ia_css_binary_find(&prim_descr, &mycs->primary_binary[i]);
 		if (err) {
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
 			return err;


