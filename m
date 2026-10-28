Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211137;
	b=Azwm+Qg3i1VhT0VpRMYncP3RFubx3jccKnxAJh0K2OyQFuTa3eST3mbtwmr13Q0oHZti
	 0oSkw6FOVEycsiTGdfVtJ4qbVAnhvUbE7KhJhFmun7gnsVC5ho/7jot8HWgUuu/8YQVXI
	 nH8/wVc6kDLdvHCLzzdyLA6I2d040uzBlFu9UIlJeJcjxRFUn3RFaTyUsagH02Bh8IZB6
	 GI7eFPrlWovVhyVl7KWXd3kctd+sVBf7UWCJNWnijWzp4N5yqvWyo7wYOdkQHhA+7DDEz
	 4tATxKK08SqVO6rBx5ijB+OlXbW7FC8F3THsGGpint0ZSpSw62asup+pyn0qiVs324Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pLWu6pvfQCr9139WMpnyaLEMDIfFC7YP5hSS10KHWA0=;
	b=I1+7xopWxtxyabfXuX4ZR8J8xP3cf2thItxid8Ep5ZiA+s5+kiiaGkoKUqJdyted5U5I
	 C0VbemsDzrHK7NQ9jpxAnRfPhdM1DjNV/6DqCuXG0xNdLq8p8twKvjlsMYk+bzxyXRWl+
	 HFoxm/DuGvBmYLmAOkeu4Haa/inLDLQA7N57IyKzFbwsPuMvIhjGBqToS66XjUK1aAx6+
	 fwb/tso4lJ8uMSafP0kBE9CA1qi8e/05Q4FuFwydfi7v4YSPkgBYYnXGKspi52hSj32xp
	 L0kXbwOV+ZeLyb0fONtBucYn6NDt3cPR/7u1UkQ7TaC8WYtZaktcCxAjDQ8rmAQkw0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtrBNf7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C5606A961;
	Wed, 28 Oct 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtrBNf7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB521F01828;
	Wed, 28 Oct 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211137;
	bh=pLWu6pvfQCr9139WMpnyaLEMDIfFC7YP5hSS10KHWA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtrBNf7Sm/xVDe49EvzBcGunkHHJqTuW9R1BZXoAgLlVPThH7u4k1cQFMIHzcQa49
	 z0eLnCPwCBds+rVV5In53JhTmXOo9RhlnS7sV6nIyPFBgMbQilt4o5Hd1RoqEILsIV
	 4ITv0dJsFSNuSlQ5x3EiB4ncxqkaOMjJ3vMwl+14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 228/571] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Wed, 28 Oct 2026 17:56:15 +0100
Message-ID: <20261028170013.414132432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 40eb4b18ad167b63644c27fa67a7400ba050379a upstream.

The "Exception info %s" print uses skb->data + 1, but the 12-byte
payload is not guaranteed to be NUL-terminated and can be read past
its end.

Bound the print with "%.*s" and skb->len - 1.

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -246,7 +246,8 @@ static void btintel_hw_error(struct hci_
 		return;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 }


