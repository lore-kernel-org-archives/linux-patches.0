Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BB82BCF7F;
	Tue, 25 Aug 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664733; cv=none; b=FwoA4pAX6iQiIkgRx1YMbo/YhiR/xejO3itat7cGqN4gKLCsAD9f+LVjiBSkr9lkaSKksikd3L7IEuuIkolqhsRot85BEke2kmf8d5jrtS9d8eVcmP41jGqL0FnfPPRKgnqdR/XhBWxUAOs2kDw025DjzY25oPznhOSmE4IJSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664733; c=relaxed/simple;
	bh=fUj7s6Rz+Kx+4AFKNdarPWoMK/55WDIA1BWOxs3I8Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY8VwfmZkVfSukvTDl0Nwcd3FxGSijMIHBehqGubCQSyJHrI6q6HR/WBP2bOTtzRiO2VMzJyjSzoHmlCfh9zlCV8HCHJDJt5k8kVQZ+3rW8vtJPy4wsLYmRe4etWXTq7OlgipAd3yIyiFTWC4eTZGVjMVVA92rhHVRFeeAZ+CqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opaw7fcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opaw7fcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C461F00A3A;
	Tue, 25 Aug 2026 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664731;
	bh=xp93ACAa/5BG+qUMRr2rbfsaO0xDb8RIIfrut7En7WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opaw7fcOTBhXjQmERR10UH7hl7NgKeW6ZJgD43io2pkOkv5yXhsIk1EGM/4ZIS0aS
	 /UeohoDCLYml8KnSdHMfhIlT+ND2XjtAnzJQfdnDHr5agw99NRpSZBcAQnTSKu2VyU
	 o+/22MK4lRIA/8tweX/ZkxJHst44JlCHoIDDqBXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 67/82] HID: nintendo: stop device IO before hid_hw_stop on probe failure
Date: Tue, 25 Aug 2026 15:25:54 +0200
Message-ID: <20260825132544.125280656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 1f74d3bff6fe04a64e02ab3661d2e0d554565aa6 upstream.

nintendo_hid_probe() calls hid_device_io_start() before joycon_init()
and joycon_leds_create().  If either fails, the error path jumps to
err_close which calls hid_hw_close()/hid_hw_stop() without first calling
hid_device_io_stop().

hid_hw_stop() does not stop device IO, so hid_input_report() may still
run and access driver data that is being torn down, resulting in a
use-after-free.

Add an err_io_stop label that calls hid_device_io_stop() before
hid_hw_close(), and point the two post-io_start error paths at it.

Fixes: 2af16c1f846b ("HID: nintendo: add nintendo switch controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2741,14 +2741,14 @@ static int nintendo_hid_probe(struct hid
 	ret = joycon_init(hdev);
 	if (ret) {
 		hid_err(hdev, "Failed to initialize controller; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	/* Initialize the leds */
 	ret = joycon_leds_create(ctlr);
 	if (ret) {
 		hid_err(hdev, "Failed to create leds; ret=%d\n", ret);
-		goto err_close;
+		goto err_io_stop;
 	}
 
 	/* Initialize the battery power supply */
@@ -2771,7 +2771,8 @@ static int nintendo_hid_probe(struct hid
 
 err_ida:
 	ida_free(&nintendo_player_id_allocator, ctlr->player_id);
-err_close:
+err_io_stop:
+	hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 err_stop:
 	hid_hw_stop(hdev);


