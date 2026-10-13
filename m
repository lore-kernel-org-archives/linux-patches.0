Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474994F85CB;
	Tue, 13 Oct 2026 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892317; cv=none; b=b0zorzqi2iqcwck/JMzAzcoUvFfUoGIr8/qU21Qg0UnM+K+q7RNUJu8iMV0MNWM8T2MrtaWs9S5LNPLI6IACIXFjrKRN4JmYSLJNMKzhuV4YIYeF0vdUpCCq6NjpK1AcSy5seAn/GVlveCWoB4e8nLzsD8UbB7OD5PKQT/hh4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892317; c=relaxed/simple;
	bh=blKCUxbCjMs3nV5lJJmpOySVWSMldgsPBAkwjw8COTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHaHM90OqnYKUBwxxrhvvCPEQjTyiU38OqjnexJyzpqBKJEO/OfNQGUUWqMz2zxja34dPuQmrTb7q/4ScX10Z8aIrT9bnD1kl/if4gETez1xqPd9AC0/sHUM14/zYlRuNZQCmCk6iboVTALeX7TUDZ5bHmYL/E3fTGgQFkzxW+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX+lONqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX+lONqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7CC1F000FF;
	Tue, 13 Oct 2026 11:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892314;
	bh=FS/aiS2bOS+n0ylSu/0AQPrUZGhwhvpBS8OOfgTu17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xX+lONqfGSxyIUGoBmWENVgKHZImAWFKkMkFcTzULouRijGEOcuf7I4tCU0IYqGf0
	 g6/kSG6B9/fYbs16r3SAyJQoplBBrNvoHD5mwJB6g8xSZKO4yWfYjAAhgb7h66uIGE
	 p0lY/Biq4eDs9lLdSda1oapum/3Cc4x0H37EhDoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.2 133/281] drm/xe/i2c: cancel the client work on remove
Date: Tue, 13 Oct 2026 13:37:29 +0200
Message-ID: <20261013112858.379449812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 611857adc9e7b0ee1239a0baf38498922ca5a12e upstream.

xe_i2c_notifier() stores the DesignWare adapter in i2c->adapter and
schedules i2c->work when the adapter is registered under the xe I2C
platform device, and xe_i2c_client_work() then instantiates the AMC
client device on that adapter.

xe_i2c_remove() tears down the AMC, unregisters the client devices,
the bus notifier and the adapter platform device, but it never drains
i2c->work. A work item that is still queued or running when the
adapter is unregistered dereferences i2c->adapter in
i2c_new_client_device() after platform_device_unregister() has
released the adapter. The work item is also embedded in the
devm-allocated struct xe_i2c, so a work item still queued after the
drm device devm unwind frees that allocation runs its callback on
freed memory.

The bus notifier is the only thing that schedules this work, and it is
unregistered after the client devices. An instance that is still queued
when the teardown runs can therefore write
i2c->client[XE_I2C_CLIENT_AMC] while the loop is unregistering and
clearing the same array, and an AMC client it instantiates late is only
cleaned up by the adapter's own child sweep in i2c_del_adapter().

Move bus_unregister_notifier() in front of the client teardown loop
and cancel the work right after it, so no new instance can be
scheduled and a queued instance is drained before the client array is
touched. A running instance still finds a live adapter, since the
adapter is unregistered later.

Fixes: f0e53aadd702 ("drm/xe: Support for I2C attached MCUs")
Link: https://lore.kernel.org/intel-xe/20260912085932.101598-1-fanwu01@zju.edu.cn/
Cc: stable@vger.kernel.org
Assisted-by: LLM, in-house static analysis tool
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260928013030.612592-1-fanwu01@zju.edu.cn
Link: https://patch.msgid.link/20261006000413.318561-2-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit a23f27d5ec11c3f418c5e5531eea34ccda2b5b20)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_i2c.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -330,12 +330,15 @@ static void xe_i2c_remove(void *data)
 	xe_i2c_irq_reset(xe);
 	xe_amc_exit(i2c);
 
+	/* Stop the notifier from arming the client work before teardown. */
+	bus_unregister_notifier(&i2c_bus_type, &i2c->bus_notifier);
+	cancel_work_sync(&i2c->work);
+
 	for (i = 0; i < XE_I2C_MAX_CLIENTS; i++) {
 		i2c_unregister_device(i2c->client[i]);
 		i2c->client[i] = NULL;
 	}
 
-	bus_unregister_notifier(&i2c_bus_type, &i2c->bus_notifier);
 	xe_i2c_unregister_adapter(i2c);
 	xe->i2c = NULL;
 }


