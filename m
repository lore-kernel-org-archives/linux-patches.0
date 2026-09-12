Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01547F2D5;
	Sat, 12 Sep 2026 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220371; cv=none; b=XSx3IU+ST5KxB2CessqMzAsp7uhbkwcJNOF6puR+qc6Q5b+qeRAzYRjYnrEjo7c4tARHh4qXAPaKOJGB9esiDAH9uBrq9YqAkiZz9Ou/EKCcRVDlVhzFYF/sKQQWAfUJXYtE94h0Ll2xTuMQ//r+7ul27mzwp7kEhySvKhDgBbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220371; c=relaxed/simple;
	bh=L1/XyAwnDtozwjW+0baoVbeZki72J7u7dcohiviyCf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKFoQLXA0rup/scc0vAInoB9BGANU8sDOE8Etwad0Ym60WcWRMhDLEgLH39LqDj8/Zr94+BL+UZlS0bnzl34Ol3q3kOioD8L80pf3kJDTH28V22MG3PNO740//gRljqm0qcsmNM0GjYJN8gZZnac5LHByhVMVTS5IFru6gCtJEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WdG3vqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WdG3vqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED87B1F000FF;
	Sat, 12 Sep 2026 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220369;
	bh=DExCDaHJFEMOGRxwZ6r02UbChYaq0yBRxHsd1keOoDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WdG3vqoWzFMLpY/fR0bXp6MmMpHHfGTPkBBM3q9XDuvYtHoC0lQsQk9R5KAa1ujQ
	 /441xLkmvxJaBhoylfjnltW9fMYt7l7QJRfBtrpnqavJ0kMFQoLCYLiw0tEmKSTzEi
	 ClAXnFeIKsyxdpenbD1qDaMSuNBRNIXKRqOmt2tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0121/1424] bnx2x: fix double free in bnx2x_init_firmware() error path
Date: Sat, 12 Sep 2026 08:42:33 +0200
Message-ID: <20260912065610.011689358@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d2796ffe38cb4155afe0eab23636295b096c27a5 upstream.

bnx2x_init_firmware() frees bp->init_ops, bp->init_data and
bp->init_ops_offsets in its error path without setting them to NULL.
The cleanup function bnx2x_release_firmware() frees the same three
pointers unconditionally, so if init_firmware fails and
release_firmware is later called (e.g. from __bnx2x_remove or through
the function state machine), all three are freed a second time.

Set each pointer to NULL after kfree() in the error path so that the
subsequent kfree(NULL) in bnx2x_release_firmware() is a safe no-op.

Fixes: 94a78b79cb5f ("bnx2x: Separated FW from the source.")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815122149.951215-1-yijiangshan@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13475,10 +13475,13 @@ static int bnx2x_init_firmware(struct bn
 
 iro_alloc_err:
 	kfree(bp->init_ops_offsets);
+	bp->init_ops_offsets = NULL;
 init_offsets_alloc_err:
 	kfree(bp->init_ops);
+	bp->init_ops = NULL;
 init_ops_alloc_err:
 	kfree(bp->init_data);
+	bp->init_data = NULL;
 request_firmware_exit:
 	release_firmware(bp->firmware);
 	bp->firmware = NULL;


