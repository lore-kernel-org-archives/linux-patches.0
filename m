Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AE14A4D2;
	Tue, 20 Feb 2024 21:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464635; cv=none; b=l774h7016RGN5n9y1QUkr5X9fVtcwieW87+n5JfGIhH8+bqYnrDJXyxo6aGAD+4uYRxXCgeusjtKzv0PsuUQP0yMPkPY6hDdDbsqRsc87ZnLlALF4axsA3tfTjvO3lQFzRMas0cdvnm6GyaG4IyDQzxz/cqn2KZDxyPdFdvKDL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464635; c=relaxed/simple;
	bh=c06zxxjvb46FY82imxKpEXQ9fhjYJCIKNt3Q6c3Etc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTpV8Rnu+hEzjGnbhr7YFoTf/wKLa0uk1ZcDTqmhfwilxKX94+4J7gH+gH4MbM/5mEPlU8379PcfetTu4ErX8F8dbsfjwipqUprrMuIfGQSexQ+wyL7LJwxE68IAAptCmLRu2zWVU7jzUadpO4o93f19FSRQkiRRrZ0vup6HVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlKJK1xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlKJK1xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A6FC433C7;
	Tue, 20 Feb 2024 21:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464635;
	bh=c06zxxjvb46FY82imxKpEXQ9fhjYJCIKNt3Q6c3Etc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlKJK1xCeaNwv/jI3FSd2ulizgW5wkMoofAl6jYcHX3ASfOzSndzb/3QGO9VTeox7
	 gnOVEWDXAVbQui1qz6uFBn8RFlGjwd/BZCa5VKjJ7ZdkXmhOFqucUXu0z96ovL/9qo
	 vLAKaxT9w7hDAJRCgGWH48l0R8Uo05H1Qttnibjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.7 087/309] usb: ucsi: Add missing ppm_lock
Date: Tue, 20 Feb 2024 21:54:06 +0100
Message-ID: <20240220205635.916546735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit c9aed03a0a683fd1600ea92f2ad32232d4736272 upstream.

Calling ->sync_write must be done while holding the PPM lock as
the mailbox logic does not support concurrent commands.

At least since the addition of partner task this means that
ucsi_acknowledge_connector_change should be called with the
PPM lock held as it calls ->sync_write.

Thus protect the only call to ucsi_acknowledge_connector_change
with the PPM. All other calls to ->sync_write already happen
under the PPM lock.

Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Cc: stable@vger.kernel.org
Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240121204123.275441-2-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -935,7 +935,9 @@ static void ucsi_handle_connector_change
 
 	clear_bit(EVENT_PENDING, &con->ucsi->flags);
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 


