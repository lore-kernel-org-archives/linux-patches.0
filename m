Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF87308F02;
	Wed, 28 Jan 2026 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615858; cv=none; b=Tmrid21wZJrTUncq3xo573hQ5XkUuf5fWKtwRWHKSF2lXTqLDnefsSDmUE/99mgPoQtwnzs2r8yqeRD8ZaWHabdHF+IoBRFXNjSxfXf61usyBN7OkkDLh8HFYJWnOxGiYKkMqZaC8Guo4iHveW4z4xziE80zLZVGTlHeSg+IZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615858; c=relaxed/simple;
	bh=Up21kJxAlHD+BIAQcIG+07rFpxGHksSZZ6a9Cwd++98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u437u27MrODbIYbu8qEYmp1x/2V7O2AMHlM6vilcgi5eDyFn32/zWCynPWbSbqWuOIsdBUeOpIJHDzYYYHRjyo54O03I3818wVkAGiRQn4JUaozZ6Ch9zGdlVQqo5n+zs5zm802UhDVcL97DmqI/eXSd8LvEgvaZIXHPwmumnSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLup3ESy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLup3ESy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754EDC4CEF7;
	Wed, 28 Jan 2026 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615857;
	bh=Up21kJxAlHD+BIAQcIG+07rFpxGHksSZZ6a9Cwd++98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLup3ESyikLsiyXIv6vPQKyyLz7hY0ivg+bSyyPPFA1sC4fD9kWe83qkruaTKQ5i2
	 k3EJ+ZVnM4B4pLlDc1ug7D2EChvcSDd9b3LnHpVZqhyyodAFwmEyAzRVxw7RTbJP4V
	 qyLXNChXAJmsKPvoaiUq/3dlLRv50syfQjKf41RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/227] vsock/test: Do not filter kallsyms by symbol type
Date: Wed, 28 Jan 2026 16:22:27 +0100
Message-ID: <20260128145348.135190559@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 5d54aa40c7b7e9dee5746cca99e9ddbcca13e895 ]

Blamed commit implemented logic to discover available vsock transports by
grepping /proc/kallsyms for known symbols. It incorrectly filtered entries
by type 'd'.

For some kernel configs having

    CONFIG_VIRTIO_VSOCKETS=m
    CONFIG_VSOCKETS_LOOPBACK=y

kallsyms reports

    0000000000000000 d virtio_transport	[vmw_vsock_virtio_transport]
    0000000000000000 t loopback_transport

Overzealous filtering might have affected vsock test suit, resulting in
insufficient/misleading testing.

Do not filter symbols by type. It never helped much.

Fixes: 3070c05b7afd ("vsock/test: Introduce get_transports()")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260116-vsock_test-kallsyms-grep-v1-1-3320bc3346f2@rbox.co
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 142c02a6834ac..bf633cde82b07 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -25,7 +25,7 @@ enum transport {
 };
 
 static const char * const transport_ksyms[] = {
-	#define x(name, symbol) "d " symbol "_transport",
+	#define x(name, symbol) " " symbol "_transport",
 	KNOWN_TRANSPORTS(x)
 	#undef x
 };
-- 
2.51.0



