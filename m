Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F733BB102;
	Tue, 12 May 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608425; cv=none; b=H89SG3XzfHjW6+48eHfKy4hx0pAihJzpaMqjkDGM377Kworq7GKlLJe3nyr5jk4PeqtoW/UG4StJE5PrIpnIjLEU9lnYHCgBDOz4dj6YoZUAW9ojm7nPQwuQrIyTMOyA448QMnKMGhI93e0qNs6wdzR24IfowGPXJh+lTEeXqKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608425; c=relaxed/simple;
	bh=Zxl/gOy1DllY3HGlmOgHL6oAy4Eqrz7sT3u7yFa0x70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMlA7QCKw53jNug4vowszHOGMa+BQJGhvuLDj5S6cPYZy9sgbV/ih3pOgCJuOnmEkLbqz6GJSDbvadvxIcqYfRpPunmymGecTEyrY6ijal4wW/3vT3rHrRxpkcYGwJ8FtfZjTPtbEH0Npu3+XLqPE6FYqMXQzhMTUmTNxgnXHSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3SHQpc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3SHQpc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2C6C2BCB0;
	Tue, 12 May 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608425;
	bh=Zxl/gOy1DllY3HGlmOgHL6oAy4Eqrz7sT3u7yFa0x70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3SHQpc00xWK25Art2MsC46f90YJRumTwYAhXbRpuAT1x4l1kz2BFmLDIDAh9JmmP
	 onLeamwzbfEsz45Vj1D8oIo5ugeHKOOrV7LViyGi9UKpQgnJzNY5A7g3jG4hiVeLWE
	 Oo226nh46vVSCyY4i8Ik6Y+nO/0Lkbx5G9Li5pKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 072/270] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Tue, 12 May 2026 19:37:53 +0200
Message-ID: <20260512173939.967109411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 0a120d96166301d7a95be75b52f843837dbd1219 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 80808e431e1e ("Bluetooth: Add l2cap_chan_ops abstraction")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1480,6 +1480,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


