Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53046331A44;
	Wed,  8 Apr 2026 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673873; cv=none; b=ejPRnN/GQz288nU472bG6piePiM/s2uFJPhrujkMGD+2VQIWxO3JaMhYy1hx0qL0p42PGaQW4s8atZng/5x3HtBQ3BK8I5uKhAw5bY1+U74B0nPY612Z+z68esS19Hq/JMzjk2r0duuw2yZPAKxPhJdXV9e6iuhoLac6RJJm2Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673873; c=relaxed/simple;
	bh=WEDPvb8aBYb3QMDObvz8KKUsqJC2KRj8nN+KSLCqPVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NivLzx4rPBzuS8AhN8bzHJduVFcqY/e9qS0fI/fYLs6pl4my93ebOb8IjXIwB4j6Tmn0NC7WmMO54ZDr4M3Qa0gMIrZDh+yvHexxFpsyei/7nUKoQfL1cdBRCeTCnCyyuIRrhn/Ui6TlhVS+uUpwHQKWFsHsuvEpxCycLpr3Yn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcwMgpJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcwMgpJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEEFC19421;
	Wed,  8 Apr 2026 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673873;
	bh=WEDPvb8aBYb3QMDObvz8KKUsqJC2KRj8nN+KSLCqPVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcwMgpJ4eBLBHAG43FvhaiBD22SkG2zsW+jVqCrUT9YllcaIqSM/P+xDGpaggMKIm
	 gA2/UPew+S6Mmryr3mO/Cj+42V8KUgVzBZfLEtG7jBZNPapNhz2r2xZ3R2MfVrmt3+
	 pM+jGFfedKWJh9V1VKX8KPUAsm+0jnC1wOLn5jIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hkbinbin <hkbinbinbin@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 123/242] Bluetooth: hci_sync: fix stack buffer overflow in hci_le_big_create_sync
Date: Wed,  8 Apr 2026 20:02:43 +0200
Message-ID: <20260408175931.691661448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hkbinbin <hkbinbinbin@gmail.com>

commit bc39a094730ce062fa034a529c93147c096cb488 upstream.

hci_le_big_create_sync() uses DEFINE_FLEX to allocate a
struct hci_cp_le_big_create_sync on the stack with room for 0x11 (17)
BIS entries.  However, conn->num_bis can hold up to HCI_MAX_ISO_BIS (31)
entries — validated against ISO_MAX_NUM_BIS (0x1f) in the caller
hci_conn_big_create_sync().  When conn->num_bis is between 18 and 31,
the memcpy that copies conn->bis into cp->bis writes up to 14 bytes
past the stack buffer, corrupting adjacent stack memory.

This is trivially reproducible: binding an ISO socket with
bc_num_bis = ISO_MAX_NUM_BIS (31) and calling listen() will
eventually trigger hci_le_big_create_sync() from the HCI command
sync worker, causing a KASAN-detectable stack-out-of-bounds write:

  BUG: KASAN: stack-out-of-bounds in hci_le_big_create_sync+0x256/0x3b0
  Write of size 31 at addr ffffc90000487b48 by task kworker/u9:0/71

Fix this by changing the DEFINE_FLEX count from the incorrect 0x11 to
HCI_MAX_ISO_BIS, which matches the maximum number of BIS entries that
conn->bis can actually carry.

Fixes: 42ecf1947135 ("Bluetooth: ISO: Do not emit LE BIG Create Sync if previous is pending")
Cc: stable@vger.kernel.org
Signed-off-by: hkbinbin <hkbinbinbin@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7105,7 +7105,8 @@ static void create_big_complete(struct h
 
 static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
 {
-	DEFINE_FLEX(struct hci_cp_le_big_create_sync, cp, bis, num_bis, 0x11);
+	DEFINE_FLEX(struct hci_cp_le_big_create_sync, cp, bis, num_bis,
+		    HCI_MAX_ISO_BIS);
 	struct hci_conn *conn = data;
 	struct bt_iso_qos *qos = &conn->iso_qos;
 	int err;


