Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270961BFE04;
	Tue, 27 Aug 2024 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770874; cv=none; b=I5UMtI0MlgM95RxJuimZGXYvYI21b6ioAxlPBWQAoWzSKx7LppYeCUCXUcqLH02qf6vub3BdpWvhVYDCXw2UceFICeeS6is60USjM4gjgkY/xUuDQy5cOg1tervzsljSt3m3TpXRH+UtdtqmBTC0hrUfEMiIo2js2gKlUmxIz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770874; c=relaxed/simple;
	bh=/Mqey5K82WrMJOoCZSQsYLL2sjFSMAKiO4tCuxgrZmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGNlWJsXifFZ+QRpl5y6STYyJyqPeL6OAoVdS8+/N55Q0yitNCsWVbtqHGpS1mxh73Y7cs5PPfhv2t52X8QqdZZggud92b+I4KO7njN9sJCid1NYB/Qz2pAQ8rABr+c1HoZVH6avHzpQkTADQoMRiwDXoi5jNlEI/2xAz7SfAiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1P2YdUpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1P2YdUpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698F9C4DDF2;
	Tue, 27 Aug 2024 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770873;
	bh=/Mqey5K82WrMJOoCZSQsYLL2sjFSMAKiO4tCuxgrZmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1P2YdUpVKqNzdJhrNQDVkOCpqKVyBauWn+MdGTbRtj+ezhvJTjoqR0iCxMiW/f5rJ
	 ySxsUwrZAE42e51EyAQi2yd5SE7gqbWBYkp2kZolT8zBTJclDCfESq0iGO1tiom2Y2
	 v1kZNYoA1pnMJCZjXyHujN3ejt96Jwa6LdxsYNZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.10 019/273] thunderbolt: Mark XDomain as unplugged when router is removed
Date: Tue, 27 Aug 2024 16:35:43 +0200
Message-ID: <20240827143834.119490375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e2006140ad2e01a02ed0aff49cc2ae3ceeb11f8d upstream.

I noticed that when we do discrete host router NVM upgrade and it gets
hot-removed from the PCIe side as a result of NVM firmware authentication,
if there is another host connected with enabled paths we hang in tearing
them down. This is due to fact that the Thunderbolt networking driver
also tries to cleanup the paths and ends up blocking in
tb_disconnect_xdomain_paths() waiting for the domain lock.

However, at this point we already cleaned the paths in tb_stop() so
there is really no need for tb_disconnect_xdomain_paths() to do that
anymore. Furthermore it already checks if the XDomain is unplugged and
bails out early so take advantage of that and mark the XDomain as
unplugged when we remove the parent router.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3392,6 +3392,7 @@ void tb_switch_remove(struct tb_switch *
 			tb_switch_remove(port->remote->sw);
 			port->remote = NULL;
 		} else if (port->xdomain) {
+			port->xdomain->is_unplugged = true;
 			tb_xdomain_remove(port->xdomain);
 			port->xdomain = NULL;
 		}


