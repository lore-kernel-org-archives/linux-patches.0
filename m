Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337512C462;
	Tue, 30 Apr 2024 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474361; cv=none; b=BMZQkEQY6wjamosKe/5FVlFkK4jMMW32AzsDNpwZDL4Xw0yzZR5Hxtbv1lNMC0rvUvhtkjug2KKuoNhgJYiIHeJXi8Sz0lvgJE9YKqCYpodOhcmEFsqbxH/Azt68WZg4jYV3Am6lAhnIRYE+RjzBLfIQWn0kaGWTvnu843PYvhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474361; c=relaxed/simple;
	bh=z5E1Qe0r1JPXHxogUTE9REMIZ7g0izBa04rQ9E7vaZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFjMpUnvYYepGAxhcVO793ohT5TmeboCjh/VpFqvmybnDwDIRhZz2hEADkOgpz9MPkGFU3KkQaUg2U+CbPSPeNZdLsPwZBEi2VA0zXYHxCjjaYdeVezkLnTHoNqZRI7QBByMO2tfpJOmh6NAJtRlY17+vMOtszt9EfvpU3r9giQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4cYw7rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4cYw7rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C0EC2BBFC;
	Tue, 30 Apr 2024 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474361;
	bh=z5E1Qe0r1JPXHxogUTE9REMIZ7g0izBa04rQ9E7vaZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4cYw7rbxJw1OpyQY1Nyd8EG0V//pjE6d8qK4s3JlvhlXuNaEVuEWqW8xg+AqeS2z
	 XcCNP7xATefpdMk+CJoN/Ao7aqnyzotCLqz5N4fkMayOPKeqenIBRZaqm2jE1zEbFp
	 pRg/hSh6qrMM4wUij+ocq9CinvgFJdpIILwNoh0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	netdev@vger.kernel.org,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 134/228] rust: phy: implement `Send` for `Registration`
Date: Tue, 30 Apr 2024 12:38:32 +0200
Message-ID: <20240430103107.669490717@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wedson Almeida Filho <walmeida@microsoft.com>

commit df70d04d56975f527b9c965322cf56e245909071 upstream.

In preparation for requiring `Send` for `Module` implementations in the
next patch.

Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: netdev@vger.kernel.org
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240328195457.225001-2-wedsonaf@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/net/phy.rs |    4 ++++
 1 file changed, 4 insertions(+)

--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -640,6 +640,10 @@ pub struct Registration {
     drivers: Pin<&'static mut [DriverVTable]>,
 }
 
+// SAFETY: The only action allowed in a `Registration` instance is dropping it, which is safe to do
+// from any thread because `phy_drivers_unregister` can be called from any thread context.
+unsafe impl Send for Registration {}
+
 impl Registration {
     /// Registers a PHY driver.
     pub fn register(


