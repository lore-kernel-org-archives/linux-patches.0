Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034297;
	b=MK6g2MER5Y3BNHS/AOYOSeu0x+xjsitBwe6D1on5GmaozQYXK7NgyqjqTfz8JlLt82yk
	 nxvHJGf887ahBjaFA1NrirKjzMJaRDHc5EhwD5qD8xo8yusrogdUmhGuxlGzjFiW/KXSM
	 xsZept+PHLHn7yDSQhoIOyXxkKrBMcKSj+YGyZjxMwBrYNzsom4tfQwImsizK4o8jGtVY
	 2QLJ4uc5hlVjdsLKIwh266DAWt+5bU2YYkv+ne/MlClA1OVm3xJsEqCLvvHUKkHcwxNWe
	 Ik5V2cOxayrMH7YB/Ea2vtUB7FGe5YExasPzBZpjdojpoELCoSMcy99nAGmYSfdZ6fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iFQD7mdAnLxfaF0Cx22H+95mZdRpnbR/qj+G8l/eIJc=;
	b=a3iZd4DLpEgO/niR36u3FwyNzwAkfeYRmgQgQZ8VwF2VYUFZXc1pU0ZoAo1VWsZsQvNP
	 8xxDFRQGJUDMeKxsmmxYLbBlZtthkjbmsODOO2drWuUiqDdTGAOXPpIMWigibURgllBSN
	 5iAdayCejqynejYygnCLZtthNzthOrM7xfx7v1+8J2F19mjYn8HLR2l9ziykc6VLoSWbq
	 vg9eGcMOqDMCAg7AqOzQxxqP5asqMCKON6UqtyFGBROSgvOKv1IMrPcYKAftAkbBe8HjN
	 19iYgR2a6257h3zXV2ge5m0/I7+DXTeYAfVDIXoGab7bf5bo1OXoetJOT+52Qha/rQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SS52DNC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47433606A31C;
	Wed, 18 Nov 2026 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SS52DNC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959901F000C4;
	Wed, 18 Nov 2026 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034297;
	bh=iFQD7mdAnLxfaF0Cx22H+95mZdRpnbR/qj+G8l/eIJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SS52DNCXCjwy2GqcfdQicknrIK3VGV4AAW8tC7t27r9t2hcgSDBzpyJqE3dSrp9x
	 qykvaF7X8MEiW7+0dMucuSOMdQMQKqdxzfefcP8w1D38xWhNwVDws4lFz0DNvKODVv
	 00jE8qM2fWObJDDwWrB2aVD25+l3++kQk41g1G/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0318/3318] scsi: snic: Fix SCSI host leak on workqueue allocation failure
Date: Wed, 18 Nov 2026 15:15:40 +0100
Message-ID: <20261118150325.382495870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 12e67eb89eb2b9516685c744d3f7de0a2d1bd701 ]

In snic_add_host(), if scsi_add_host() succeeds but
alloc_ordered_workqueue() fails, the function returns -ENOMEM with
shost->work_q left as NULL. The caller's error path then calls
snic_del_host(), which returns early when !shost->work_q without calling
scsi_remove_host(). The Scsi_Host remains registered in sysfs as a zombie
device even after the probe has failed. This causes:

 - The leaked host remains visible in /sys/class/scsi_host/ after probe
   failure, with state "running".

 - Subsequent SCSI host numbering is permanently shifted (the leaked host
   ID from ida_alloc() is never reclaimed).

 - Memory leak: the Scsi_Host allocation can never be freed because
   device_add() took a reference that can only be released by device_del()
   inside scsi_remove_host().

Fix by adding scsi_remove_host() in the workqueue allocation failure path
inside snic_add_host(), undoing the successful scsi_add_host() before
returning the error. This is cleaner than modifying snic_del_host() because
snic_del_host() is called from a shared error label that also serves paths
where snic_add_host() was never invoked.

Reproducer (requires no real SNIC hardware):

 - Build CONFIG_SCSI_SNIC=y (built-in)

 - Add snic.test_mode=1 snic.inject_wq_fail=1 to kernel cmdline

 - Boot with a PCI device matching the snic driver (e.g. QEMU edu device,
   PCI ID 0x1234:0x11e8, temporarily added to the driver's PCI ID table)

Before the fix:

  # /sys/class/scsi_host/ contains a zombie host0:
  $ cat /sys/class/scsi_host/host0/proc_name
  snic_scsi
  $ cat /sys/class/scsi_host/host0/state
  running
  # ata_piix gets host1, host2 (host0 stuck):
  scsi host1: ata_piix
  scsi host2: ata_piix

After the fix:

  # host0 is properly freed and reused by ata_piix:
  scsi host0: ata_piix
  scsi host1: ata_piix
  # No zombie host in /sys/class/scsi_host/

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Link: https://patch.msgid.link/20260727073438.209673-1-chenchangcheng@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/snic/snic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index cc824dcfe7da4..e68388ae259e4 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -306,6 +306,7 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
 
+		scsi_remove_host(shost);
 		ret = -ENOMEM;
 	}
 
-- 
2.53.0



