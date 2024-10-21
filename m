Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971DE1E3DF0;
	Mon, 21 Oct 2024 10:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507412; cv=none; b=VHOj2RAZAHkqecC1JnQBwIH33YuomnhfxnOWNLn1HTnQLhUu5LH95TKZyNqkIS+2dQLOFKv7BBBM2eZXih+qb3fhpVGj02bdHvl8K9QSF3mWtMhq8xrYbwMV7HABzFe0RGM8dbOA2TFtZeUXXD+mEtNHeDMuy0NtkBts+laF6HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507412; c=relaxed/simple;
	bh=KY/HsPJjkCk2MYdX/RlEBwB3PUmQbPWX3T3KlqB+bw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emb3efsyyZ0ID5MDgSVKSghxZYjiOAuKEkY8WJ3g10VWIvlexu8g/0bH2UroCoXg1tXID4FMdWtkmzIl/JiGI7ODYq/3uNImHI4jJFt9mtMlGAZ7Secr/CMcNUonKND0weu7ve3lKeqLUIDD4kw4PtRUmOv8U9gqFpvn2oqtS54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiZDmu6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiZDmu6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F46C4CEC3;
	Mon, 21 Oct 2024 10:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507412;
	bh=KY/HsPJjkCk2MYdX/RlEBwB3PUmQbPWX3T3KlqB+bw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiZDmu6xWjAv46WZJtDSI8AEhhTzE0RPUuZtoLwOhdgTjhfI7q+fxFiN0sl4bC/hC
	 lsrjr/p0Or3jvG8y9cabBIIphS9q3M39Opjz4RdHyTivqgWGvQiuMZOyrnn/z254IM
	 gZjAHwwY4hTsaiy5vMxTdrOXYuhPJwdibrZ/0bnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 69/91] Bluetooth: Remove debugfs directory on module init failure
Date: Mon, 21 Oct 2024 12:25:23 +0200
Message-ID: <20241021102252.513151651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Thompson <dev@aaront.org>

commit 1db4564f101b47188c1b71696bd342ef09172b22 upstream.

If bt_init() fails, the debugfs directory currently is not removed. If
the module is loaded again after that, the debugfs directory is not set
up properly due to the existing directory.

  # modprobe bluetooth
  # ls -laF /sys/kernel/debug/bluetooth
  total 0
  drwxr-xr-x  2 root root 0 Sep 27 14:26 ./
  drwx------ 31 root root 0 Sep 27 14:25 ../
  -r--r--r--  1 root root 0 Sep 27 14:26 l2cap
  -r--r--r--  1 root root 0 Sep 27 14:26 sco
  # modprobe -r bluetooth
  # ls -laF /sys/kernel/debug/bluetooth
  ls: cannot access '/sys/kernel/debug/bluetooth': No such file or directory
  #

  # modprobe bluetooth
  modprobe: ERROR: could not insert 'bluetooth': Invalid argument
  # dmesg | tail -n 6
  Bluetooth: Core ver 2.22
  NET: Registered PF_BLUETOOTH protocol family
  Bluetooth: HCI device and connection manager initialized
  Bluetooth: HCI socket layer initialized
  Bluetooth: Faking l2cap_init() failure for testing
  NET: Unregistered PF_BLUETOOTH protocol family
  # ls -laF /sys/kernel/debug/bluetooth
  total 0
  drwxr-xr-x  2 root root 0 Sep 27 14:31 ./
  drwx------ 31 root root 0 Sep 27 14:26 ../
  #

  # modprobe bluetooth
  # dmesg | tail -n 7
  Bluetooth: Core ver 2.22
  debugfs: Directory 'bluetooth' with parent '/' already present!
  NET: Registered PF_BLUETOOTH protocol family
  Bluetooth: HCI device and connection manager initialized
  Bluetooth: HCI socket layer initialized
  Bluetooth: L2CAP socket layer initialized
  Bluetooth: SCO socket layer initialized
  # ls -laF /sys/kernel/debug/bluetooth
  total 0
  drwxr-xr-x  2 root root 0 Sep 27 14:31 ./
  drwx------ 31 root root 0 Sep 27 14:26 ../
  #

Cc: stable@vger.kernel.org
Fixes: ffcecac6a738 ("Bluetooth: Create root debugfs directory during module init")
Signed-off-by: Aaron Thompson <dev@aaront.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -797,6 +797,7 @@ cleanup_sysfs:
 	bt_sysfs_cleanup();
 cleanup_led:
 	bt_leds_cleanup();
+	debugfs_remove_recursive(bt_debugfs);
 	return err;
 }
 


