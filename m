Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83743211493;
	Thu, 12 Dec 2024 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024345; cv=none; b=JdvkLAJmt1EaE3P1Oo2sXeh/UDyYygMlkMHY7uzZzpJFY4JY3vI1soFu8/0bqsAojCoxFxn5Zi0HAM4vPmfPBwCKXpBX7BmI1NQyK2EwvCzQXx+pSMD8dmfh0RX/Q/Qw5xAKADv/TXaVb4drML2EDA18M4CSQ2ErQrQl0e53eJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024345; c=relaxed/simple;
	bh=ca9SIfFhrf4++LBEf+SFnEMetWGkHcH8LApfcLMSY2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDBLD9VcJFgvtD5jmKNkr4dWN1JbK6/U19Fdsd8AYRxtPULwMfy1ALNXsSaCWfSQKDurjoOKH4NeMZrUfXLO0FZhAcXi9mRlZ8Pt6oqUiuxSbgTkYKJyjZspfYCWMHCM3PPZIEwd+BYvW3CcArwAWjdPpbTn8dF1qlbJ/B1rtmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7YOz7PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7YOz7PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D6AC4CECE;
	Thu, 12 Dec 2024 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024345;
	bh=ca9SIfFhrf4++LBEf+SFnEMetWGkHcH8LApfcLMSY2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7YOz7PEx0XqUNAlRwwYGUEbJNKqbfxBnur9hnMvcwOdw9DMnlCtC2JGtXwPj6iZQ
	 0Z+QUZgOam5iF8leMuXjidzUy68XOkZa7YoVsXmIXrlMRtJ8jbUM/N4KzVaUr6GUhe
	 D6Lv9BUQ1A9GmbDNKoh9Vi0rGgKt04Ohu+G2jTY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.10 266/459] platform/chrome: cros_ec_typec: fix missing fwnode reference decrement
Date: Thu, 12 Dec 2024 16:00:04 +0100
Message-ID: <20241212144304.111842741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9c41f371457bd9a24874e3c7934d9745e87fbc58 upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() upon early exits (return, break, goto) to decrement
the fwnode's refcount, and avoid levaing a node reference behind.

Add the missing fwnode_handle_put() after the common label for all error
paths.

Cc: stable@vger.kernel.org
Fixes: fdc6b21e2444 ("platform/chrome: Add Type C connector class driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241013-cross_ec_typec_fwnode_handle_put-v2-1-9182b2cd7767@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -294,6 +294,7 @@ static int cros_typec_init_ports(struct
 	return 0;
 
 unregister_ports:
+	fwnode_handle_put(fwnode);
 	cros_unregister_ports(typec);
 	return ret;
 }


