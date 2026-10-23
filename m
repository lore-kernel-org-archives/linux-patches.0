Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774832;
	b=QgL7f3D4WPC0HrB5s7T6/fGBQr8ZcXM0LHmf6cV46oyLUgZvC1nhqCNXweCAAcLIL3uc
	 RNRWP3gYwtZE0dZHfjd4bmT1BmPz79KguULMnOWyaVXEO3kO9uLVvXJRdKzHKDA9WMeeM
	 Hb/4JBnppMtY1/FbB/b9g2VnWzfRzV3jZ76FSI74plq5ZxaWpFaxOiP+TjFF2CEROS27m
	 2U7JKHFqnBOsmr/jcRSMJnMsD7f8HmUSxxhD86Wpr2fgBFCq5UfyvdwuYoVvh3f96I3/z
	 fNs/cNkpkYNWMMAD/zKLBOna30YCK/X18QLXJ86MuqXwOn13pq03n9NpPdDBTS16PPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWXzOczrAVRwEcvpzS7wT+ApkI6X9qcvzHG2Q9TqT40=;
	b=cudovDTjLqyynbDw/uI5nn/e+k/0XW0kX29A0Dc1IShhUhDPSz2o+CmiCA3TyFQ2mQIA
	 9Y3Zj57Cr9lq17m33LBpdtLRRhjBMAKT4wBUt35T4J+JipWDtoUO13h5qOzsRSrNEBv2J
	 mVytoIWXZSikQIGfd5vtJNHQrsXc4a7fLhwatkLENCWCpEDEY9ov1c5Co07QSX5Dpy1Wz
	 jtbAhYs0NmkVBkdHawINJYR287BZmnrSgQpNRz4uZWTV6RjfrovSiLi3ZFt2rSAdd75P0
	 /EebBtuXyyiC/nssnl128Gs+zjoAHvuisrrmkYKGiXR79tXaEKyZ5PiovWXsk65UPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSf4dB6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D90606A325;
	Fri, 23 Oct 2026 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSf4dB6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FCE1F01825;
	Fri, 23 Oct 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774831;
	bh=JWXzOczrAVRwEcvpzS7wT+ApkI6X9qcvzHG2Q9TqT40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSf4dB6xzARX6uFOauOXxwdLzN+5TYecU/SIbu9XrtqkhwEv9M+UrzNLoa3mzNgK1
	 fCWHkRJt9TpLi9frPgeUMNyNzVfc6vZ1jTXzxnwMWygJa83toWdCYfj/nsjUJqOITN
	 iQaftxXplKb5ozI5zh5lguvDCkzZgP0IEz7dPIzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abelvesa@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 135/242] gpio: shared: gracefully handle no-device lookup of shared GPIOs
Date: Fri, 23 Oct 2026 18:39:37 +0200
Message-ID: <20261023163716.971115078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit cf73c3fc03c43a8a86fd487c62390b4744eff9ec upstream.

We use platform lookup tables for shared GPIOs. This mechanism needs a
struct device to work so fwnode-based lookup with no device associated
currently causes a NULL-pointer deference.

Adding this functionality will require a larger rework and it has never
worked anyway so add a check that allows the kernel to gracefully handle
this situation with an error ahead of implementing that functionality as
a new feature.

Cc: stable@vger.kernel.org
Reported-by: Abel Vesa <abelvesa@kernel.org>
Fixes: a060b8c511ab ("gpiolib: implement low-level, shared GPIO support")
Link: https://patch.msgid.link/20261014-gpio-shared-fwnode-lookup-v4-2-2253ad645fd6@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-shared.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index 6acfec73b734..8c9ac9d93304 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -449,9 +449,14 @@ static bool gpio_shared_dev_is_reset_gpio(struct device *consumer,
 int gpio_shared_add_proxy_lookup(struct device *consumer, struct fwnode_handle *fwnode,
 				 const char *con_id, unsigned long lflags)
 {
-	const char *dev_id = dev_name(consumer);
 	struct gpio_shared_entry *entry;
 	struct gpio_shared_ref *ref;
+	const char *dev_id;
+
+	if (!consumer)
+		return -EOPNOTSUPP;
+
+	dev_id = dev_name(consumer);
 
 	list_for_each_entry(entry, &gpio_shared_list, list) {
 		list_for_each_entry(ref, &entry->refs, list) {
-- 
2.56.0



